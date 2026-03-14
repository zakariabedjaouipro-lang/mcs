-- ═══════════════════════════════════════════════════════════════════════════════
-- QUICK FIX: Countries 404 Error
-- Run this in Supabase SQL Editor to immediately fix the issue
-- ═══════════════════════════════════════════════════════════════════════════════

-- Step 1: Check if table exists
SELECT EXISTS (
  SELECT FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name = 'countries'
) as table_exists;

-- Step 2: If table exists, check data
SELECT COUNT(*) as total_countries, 
       COUNT(CASE WHEN is_supported THEN 1 END) as supported_countries
FROM countries;

-- Step 3: Disable strict RLS temporarily (QUICK FIX)
ALTER TABLE countries DISABLE ROW LEVEL SECURITY;

-- Step 4: Re-enable RLS with public access (PROPER FIX)
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;

-- Drop old policies
DROP POLICY IF EXISTS "Active countries are viewable by everyone" ON countries;
DROP POLICY IF EXISTS "Supported countries are viewable by everyone" ON countries;
DROP POLICY IF EXISTS "Service role can manage countries" ON countries;

-- Create new public-access policy
CREATE POLICY "public_read_countries"
  ON countries FOR SELECT
  USING (is_supported = true);

-- Step 5: Test the query (should return > 0)
SELECT id, name, name_ar, iso2_code, phone_code 
FROM countries 
WHERE is_supported = true 
ORDER BY name ASC 
LIMIT 10;

-- ═══════════════════════════════════════════════════════════════════════════════
-- If the table doesn't exist, insert the seed data
-- ═══════════════════════════════════════════════════════════════════════════════

-- Run this only if table needs to be created from scratch:
-- Copy and paste the full migration from:
-- supabase/migrations/20260304120002_create_countries_table.sql
