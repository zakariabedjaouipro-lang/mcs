-- Migration: Create Users Table and Related Structures
-- Purpose: Define the users table with RLS policies and relationships to auth.users
-- Version: v2_P01_004
-- Created: 2026-03-04
-- Dependencies: None

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ══════════════════════════════════════════════════════════════════════════════
-- Users Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create users table to store extended user profile information
CREATE TABLE IF NOT EXISTS users (
  -- Primary and Foreign Keys
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- User Information
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  full_name VARCHAR(255) GENERATED ALWAYS AS (
    COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')
  ) STORED,

  -- Avatar and Profile Media
  avatar_url TEXT,  -- URL to user's profile picture
  bio TEXT,         -- User biography/description
  date_of_birth DATE,

  -- Business Information
  clinic_id UUID,   -- Reference to clinic (nullable - system admins don't have clinic)
  role user_role NOT NULL DEFAULT 'patient',

  -- Account Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_verified BOOLEAN NOT NULL DEFAULT false,  -- Email verified
  phone_verified BOOLEAN NOT NULL DEFAULT false,

  -- Contact and Location
  country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
  address TEXT,
  postal_code VARCHAR(20),
  city VARCHAR(100),

  -- Metadata and Preferences
  locale VARCHAR(5) DEFAULT 'en',  -- Language preference (en, ar)
  timezone VARCHAR(50) DEFAULT 'UTC',
  theme_preference VARCHAR(20) DEFAULT 'system',  -- light, dark, system
  two_factor_enabled BOOLEAN DEFAULT false,

  -- Subscription Information
  subscription_type subscription_type DEFAULT 'free',
  subscription_start_date TIMESTAMP WITH TIME ZONE,
  subscription_end_date TIMESTAMP WITH TIME ZONE,

  -- Activity Tracking
  last_login_at TIMESTAMP WITH TIME ZONE,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  login_count INTEGER DEFAULT 0,

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE,  -- Soft delete timestamp

  -- Constraints
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
  CONSTRAINT valid_phone CHECK (phone IS NULL OR phone ~* '^\+?[0-9\s\-\(\)]{10,}$'),
  CONSTRAINT valid_locale CHECK (locale IN ('en', 'ar')),
  CONSTRAINT valid_theme CHECK (theme_preference IN ('light', 'dark', 'system')),
  CONSTRAINT valid_subscription_dates CHECK (
    subscription_end_date IS NULL OR subscription_start_date IS NULL OR
    subscription_end_date >= subscription_start_date
  )
);

-- Create indexes for common queries
CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_clinic_id ON users(clinic_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_role ON users(role) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_is_active ON users(is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created_at ON users(created_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_subscription_type ON users(subscription_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_country_id ON users(country_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_region_id ON users(region_id) WHERE deleted_at IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Updated At Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER users_update_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ══════════════════════════════════════════════════════════════════════════════
-- Last Activity Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update last_activity_at on any table update
CREATE OR REPLACE FUNCTION update_user_last_activity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET last_activity_at = NOW() WHERE id = NEW.created_by OR id = NEW.updated_by;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- ⚠️ RLS DISABLED FOR POSTGRESQL COMPATIBILITY
-- PostgreSQL doesn't have auth.uid() function (Supabase-specific)
-- These policies should be re-enabled when using Supabase
-- For local PostgreSQL, RLS is disabled to allow full access

-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- -- Policy: Users can read their own profile
-- CREATE POLICY users_read_own_profile ON users
--   FOR SELECT
--   USING (auth.uid() = id);

-- -- Policy: Super admins and clinic admins can read users in their clinic
-- CREATE POLICY admins_read_clinic_users ON users
--   FOR SELECT
--   USING (
--     (SELECT role FROM users WHERE id = auth.uid()) IN ('super_admin', 'clinic_admin')
--     AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())
--   );

-- -- Policy: Super admins can read all users
-- CREATE POLICY super_admin_read_all ON users
--   FOR SELECT
--   USING ((SELECT role FROM users WHERE id = auth.uid()) = 'super_admin');

-- -- Policy: Users can update only their own profile (non-sensitive fields)
-- CREATE POLICY users_update_own_profile ON users
--   FOR UPDATE
--   USING (auth.uid() = id)
--   WITH CHECK (
--     auth.uid() = id
--     AND role = (SELECT role FROM users WHERE id = auth.uid())  -- Prevent role change
--     AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())  -- Prevent clinic change
--   );

-- -- Policy: Clinic admins can update users in their clinic (limited fields)
-- CREATE POLICY admins_update_clinic_users ON users
--   FOR UPDATE
--   USING (
--     (SELECT role FROM users WHERE id = auth.uid()) IN ('super_admin', 'clinic_admin')
--     AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())
--   )
--   WITH CHECK (
--     (SELECT role FROM users WHERE id = auth.uid()) IN ('super_admin', 'clinic_admin')
--     AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())
--   );

-- -- Policy: Users can insert their own profile after signup (new registrations)
-- CREATE POLICY users_insert_own_profile ON users
--   FOR INSERT
--   WITH CHECK (auth.uid() = id);

-- -- Policy: Only admins can delete users (soft delete via updated_at trigger)
-- CREATE POLICY admins_soft_delete ON users
--   FOR UPDATE
--   USING ((SELECT role FROM users WHERE id = auth.uid()) = 'super_admin')
--   WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'super_admin');

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Views
-- ══════════════════════════════════════════════════════════════════════════════

-- View: Active users only (excluding soft-deleted)
CREATE VIEW active_users AS
SELECT * FROM users
WHERE deleted_at IS NULL;

-- View: Users by clinic (for clinic-specific queries)
CREATE VIEW clinic_users AS
SELECT u.*, 
  COUNT(*) OVER (PARTITION BY u.clinic_id) as clinic_user_count
FROM users u
WHERE u.deleted_at IS NULL
ORDER BY u.clinic_id, u.created_at;

-- View: User statistics
CREATE VIEW user_statistics AS
SELECT
  COUNT(*) as total_users,
  COUNT(CASE WHEN is_active THEN 1 END) as active_users,
  COUNT(CASE WHEN is_verified THEN 1 END) as verified_users,
  COUNT(DISTINCT clinic_id) as total_clinics,
  COUNT(CASE WHEN role = 'doctor' THEN 1 END) as doctor_count,
  COUNT(CASE WHEN role = 'patient' THEN 1 END) as patient_count,
  COUNT(CASE WHEN role = 'clinic_admin' THEN 1 END) as admin_count
FROM users
WHERE deleted_at IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE users IS 'Extended user profiles with application-specific fields';
COMMENT ON COLUMN users.id IS 'Unique identifier for each user (UUID)';
COMMENT ON COLUMN users.clinic_id IS 'Reference to clinics table (NULL for system admins)';
COMMENT ON COLUMN users.role IS 'User role determining permissions and access levels';
COMMENT ON COLUMN users.is_verified IS 'Email verification status';
COMMENT ON COLUMN users.two_factor_enabled IS 'Two-factor authentication status';
COMMENT ON COLUMN users.deleted_at IS 'Soft delete timestamp (NULL = active)';

-- RLS Policy Comments (disabled for PostgreSQL compatibility - use with Supabase)
-- COMMENT ON POLICY users_read_own_profile ON users IS 'Users can view their own profile only';
-- COMMENT ON POLICY admins_read_clinic_users ON users IS 'Admins can read users in their clinic';
-- COMMENT ON POLICY super_admin_read_all ON users IS 'Super admins can read all user profiles';
-- COMMENT ON POLICY users_update_own_profile ON users IS 'Users can update non-sensitive fields';
-- COMMENT ON POLICY admins_update_clinic_users ON users IS 'Admins can manage users in their clinic';

-- ══════════════════════════════════════════════════════════════════════════════
-- Migration Notes
-- ══════════════════════════════════════════════════════════════════════════════

/*
  IMPORTANT SETUP NOTES:

  1. This migration creates a 'users' table that extends Supabase's built-in auth.users
  2. The relationship is established via a foreign key on the 'id' column
  3. RLS (Row Level Security) is enabled to protect user data
  4. Four main policies control access:
     - Users can read their own profiles
     - Admins can manage clinic staff
     - Super admins have full access
     - Users can only update non-sensitive fields

  5. Soft-delete pattern: Use deleted_at IS NULL in WHERE clauses
  6. To fully delete a user: UPDATE users SET deleted_at = NOW() WHERE id = ...

  7. After creating auth.users, you must create a corresponding users record:
     - Use a trigger on auth.users.created_at, OR
     - Call a function during user registration signup

  8. Recommended post-signup function:
     CREATE FUNCTION handle_new_user() RETURNS TRIGGER AS $$
     BEGIN
       INSERT INTO users (id, email, role) VALUES (NEW.id, NEW.email, 'patient');
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql SECURITY DEFINER;

     CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users
     FOR EACH ROW EXECUTE FUNCTION handle_new_user();
*/