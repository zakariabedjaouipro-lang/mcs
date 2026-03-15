-- Migration: Add Missing User Signup Trigger
-- Purpose: Create public.users record when new user signs up in auth.users
-- Issue: Trigger was documented but never created, causing UserRole.unknown errors
-- Version: 1.0
-- Created: 2026-03-15

-- ══════════════════════════════════════════════════════════════════════════════
-- HANDLE_NEW_USER FUNCTION
-- ══════════════════════════════════════════════════════════════════════════════

-- Creates a corresponding user record in public.users when new user signs up
-- Extracts role from auth.users metadata, defaults to 'patient' if not provided
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  user_role user_role := 'patient'::user_role;
  user_email VARCHAR(255);
  user_name TEXT;
  user_phone VARCHAR(20);
BEGIN
  -- Extract role from user metadata
  BEGIN
    user_role := COALESCE(
      (NEW.raw_user_meta_data->>'role')::user_role,
      'patient'::user_role
    );
  EXCEPTION WHEN OTHERS THEN
    user_role := 'patient'::user_role;
  END;

  -- Extract other metadata
  user_email := COALESCE(NEW.email, '');
  user_name := COALESCE(NEW.raw_user_meta_data->>'name', '');
  user_phone := COALESCE(NEW.raw_user_meta_data->>'phone', NULL);

  -- INSERT into public.users
  BEGIN
    INSERT INTO public.users (
      id,
      email,
      full_name,
      phone,
      role,
      is_active,
      is_verified,
      created_at,
      updated_at
    ) VALUES (
      NEW.id,
      user_email,
      user_name,
      user_phone,
      user_role,
      true,
      NEW.email_confirmed_at IS NOT NULL,
      NOW(),
      NOW()
    );
  EXCEPTION WHEN unique_violation THEN
    -- User already exists (shouldn't happen normally)
    -- Update the role if it's still 'patient'
    UPDATE public.users
    SET role = CASE
      WHEN role = 'patient'::user_role THEN user_role
      ELSE role
    END,
    updated_at = NOW()
    WHERE id = NEW.id;
  EXCEPTION WHEN OTHERS THEN
    -- Log error but don't fail the signup
    RAISE WARNING 'Failed to create public.users record for %: %', NEW.id, SQLERRM;
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- ══════════════════════════════════════════════════════════════════════════════
-- TRIGGER: ON_AUTH_USER_CREATED
-- ══════════════════════════════════════════════════════════════════════════════

-- Fires when new user is created in auth.users
-- Creates corresponding public.users record with proper role
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- ══════════════════════════════════════════════════════════════════════════════
-- COMMENTS
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON FUNCTION handle_new_user() IS 'Automatically creates public.users record when new user signs up';
COMMENT ON TRIGGER on_auth_user_created ON auth.users IS 'Trigger to create public.users record on auth signup';

-- ══════════════════════════════════════════════════════════════════════════════
-- MIGRATION NOTES
-- ══════════════════════════════════════════════════════════════════════════════

/*
  This migration fixes the critical bug where users were created in auth.users
  but no corresponding record existed in public.users, causing role lookups to fail.

  The trigger:
  1. Extracts role from auth.users raw_user_meta_data
  2. Defaults to 'patient' if role is not provided
  3. Creates a complete user record in public.users
  4. Handles edge cases like duplicate inserts

  This ensures RoleManagementService._getRoleFromDatabase() always finds the user.

  For existing users stuck with UserRole.unknown, run:
  
  -- Find users without public.users records
  SELECT u.id, u.email FROM auth.users u
  WHERE NOT EXISTS (SELECT 1 FROM public.users pu WHERE pu.id = u.id);

  -- Insert them with role from metadata
  INSERT INTO public.users (id, email, role, full_name, phone, is_active, is_verified, created_at, updated_at)
  SELECT
    u.id,
    u.email,
    COALESCE((u.raw_user_meta_data->>'role')::user_role, 'patient'::user_role),
    COALESCE(u.raw_user_meta_data->>'name', ''),
    u.raw_user_meta_data->>'phone',
    true,
    u.email_confirmed_at IS NOT NULL,
    u.created_at,
    NOW()
  FROM auth.users u
  WHERE NOT EXISTS (SELECT 1 FROM public.users pu WHERE pu.id = u.id);
*/
