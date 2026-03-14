-- Migration: Fix Countries Table Public Access
-- Purpose: Fix RLS policies to allow public/unauthenticated access to countries
-- Version: v2_P01_002_fix
-- Created: 2026-03-12
-- Status: CRITICAL FIX

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ══════════════════════════════════════════════════════════════════════════════
-- Issue: Users during registration/login get 404 when fetching countries
-- Fix: Add explicit policy for public access
-- ══════════════════════════════════════════════════════════════════════════════

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Active countries are viewable by everyone" ON countries;
DROP POLICY IF EXISTS "Supported countries are viewable by everyone" ON countries;
DROP POLICY IF EXISTS "Service role can manage countries" ON countries;
DROP POLICY IF EXISTS "Public can read countries" ON countries;

-- ══════════════════════════════════════════════════════════════════════════════
-- New RLS Policies - Allows public access
-- ══════════════════════════════════════════════════════════════════════════════

-- Policy 1: Everyone (authenticated or not) can view all supported countries
CREATE POLICY "Public read access to supported countries"
  ON countries FOR SELECT
  USING (is_supported = true);

-- Policy 2: Everyone (authenticated or not) can view all active countries  
CREATE POLICY "Public read access to active countries"
  ON countries FOR SELECT
  USING (is_active = true);

-- Policy 3: Super admins can manage countries (via service role)
CREATE POLICY "Service role can manage countries"
  ON countries FOR ALL
  USING (auth.role() = 'service_role');

-- ══════════════════════════════════════════════════════════════════════════════
-- Ensure table has correct structure
-- ══════════════════════════════════════════════════════════════════════════════

-- Verify is_supported column has correct data
UPDATE countries SET is_supported = true WHERE is_supported IS NULL;
UPDATE countries SET is_active = true WHERE is_active IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Verify data exists
-- ══════════════════════════════════════════════════════════════════════════════

-- This query should return at least the core countries
-- SELECT COUNT(*) as total, COUNT(CASE WHEN is_supported THEN 1 END) as supported
-- FROM countries;
