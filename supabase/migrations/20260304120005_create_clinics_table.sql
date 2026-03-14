-- Migration: Create Clinics Table
-- Purpose: Store medical clinic information
-- Version: v2_P02_002
-- Created: 2026-03-04
-- Dependencies: v2_P01_002_create_countries_table.sql, v2_P01_003_create_regions_table.sql

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ══════════════════════════════════════════════════════════════════════════════
-- Clinics Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create clinics table to store medical clinic information
CREATE TABLE IF NOT EXISTS clinics (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Clinic Information
  name VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255),
  description TEXT,
  description_ar TEXT,
  
  -- Contact Information
  address TEXT NOT NULL,
  city VARCHAR(100) NOT NULL,
  region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
  country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(255),
  website VARCHAR(255),
  
  -- Branding and Media
  logo_url TEXT,
  banner_url TEXT,
  
  -- Operating Hours
  opening_hours JSONB,  -- JSON object with daily hours
  
  -- Geographic Location
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  
  -- Subscription Information
  subscription_id UUID,  -- Reference to subscription_codes table
  subscription_type subscription_type DEFAULT 'trial',
  subscription_start_date TIMESTAMP WITH TIME ZONE,
  subscription_end_date TIMESTAMP WITH TIME ZONE,
  is_trial BOOLEAN DEFAULT true,
  

  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,  -- Featured clinics shown prominently
  
  -- Statistics
  total_patients INTEGER DEFAULT 0,
  total_doctors INTEGER DEFAULT 0,
  total_appointments INTEGER DEFAULT 0,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_latitude CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
  CONSTRAINT valid_longitude CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180),
  CONSTRAINT valid_phone CHECK (phone ~* '^\+?[0-9\s\-\(\)]{10,}$'),
  CONSTRAINT valid_email CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_clinics_region_id ON clinics(region_id) WHERE is_active = true;
CREATE INDEX idx_clinics_country_id ON clinics(country_id) WHERE is_active = true;
CREATE INDEX idx_clinics_subscription_id ON clinics(subscription_id);
CREATE INDEX idx_clinics_is_active ON clinics(is_active);
CREATE INDEX idx_clinics_is_verified ON clinics(is_verified);
CREATE INDEX idx_clinics_is_featured ON clinics(is_featured) WHERE is_featured = true;
CREATE INDEX idx_clinics_created_at ON clinics(created_at DESC);
CREATE INDEX idx_clinics_name ON clinics(name) WHERE is_active = true;
CREATE INDEX idx_clinics_city ON clinics(city) WHERE is_active = true;
CREATE INDEX idx_clinics_subscription_type ON clinics(subscription_type) WHERE is_active = true;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on clinics table
ALTER TABLE clinics ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active and verified clinics
CREATE POLICY "Active verified clinics are viewable by everyone"
  ON clinics FOR SELECT
  USING (is_active = true AND is_verified = true);

-- Policy: Clinic owners can view their own clinic
CREATE POLICY "Clinic owners can view their clinic"
  ON clinics FOR SELECT
  USING (created_by = auth.uid());

-- Policy: Clinic owners can update their clinic
CREATE POLICY "Clinic owners can update their clinic"
  ON clinics FOR UPDATE
  USING (created_by = auth.uid());

-- Policy: Clinic owners can delete their clinic
CREATE POLICY "Clinic owners can delete their clinic"
  ON clinics FOR DELETE
  USING (created_by = auth.uid());

-- Policy: Super admins can manage all clinics
CREATE POLICY "Super admins can manage all clinics"
  ON clinics FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_clinics_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER clinics_update_updated_at
  BEFORE UPDATE ON clinics
  FOR EACH ROW
  EXECUTE FUNCTION update_clinics_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE clinics IS 'Medical clinic information';
COMMENT ON COLUMN clinics.id IS 'Primary key (UUID)';
COMMENT ON COLUMN clinics.name IS 'Clinic name in English';
COMMENT ON COLUMN clinics.name_ar IS 'Clinic name in Arabic';
COMMENT ON COLUMN clinics.address IS 'Physical address';
COMMENT ON COLUMN clinics.city IS 'City name';
COMMENT ON COLUMN clinics.region_id IS 'Foreign key reference to regions table';
COMMENT ON COLUMN clinics.country_id IS 'Foreign key reference to countries table';
COMMENT ON COLUMN clinics.opening_hours IS 'JSON object containing opening hours for each day of the week';
COMMENT ON COLUMN clinics.latitude IS 'Geographic latitude for map display';
COMMENT ON COLUMN clinics.longitude IS 'Geographic longitude for map display';
COMMENT ON COLUMN clinics.subscription_id IS 'Foreign key reference to subscription_codes table';
COMMENT ON COLUMN clinics.subscription_type IS 'Type of subscription plan';
COMMENT ON COLUMN clinics.is_trial IS 'Whether this is a trial subscription';
COMMENT ON COLUMN clinics.is_active IS 'Whether the clinic is active';
COMMENT ON COLUMN clinics.is_verified IS 'Whether the clinic has been verified';
COMMENT ON COLUMN clinics.is_featured IS 'Whether this clinic is featured';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to check if clinic subscription is expired
CREATE OR REPLACE FUNCTION is_clinic_subscription_expired(clinic_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  SELECT subscription_end_date INTO end_date
  FROM clinics
  WHERE id = clinic_id;
  
  RETURN end_date IS NULL OR end_date < NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to get days remaining in subscription
CREATE OR REPLACE FUNCTION get_clinic_subscription_days_remaining(clinic_id UUID)
RETURNS INTEGER AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  SELECT subscription_end_date INTO end_date
  FROM clinics
  WHERE id = clinic_id;
  
  IF end_date IS NULL THEN
    RETURN 0;
  END IF;
  
  RETURN GREATEST(0, EXTRACT(DAY FROM (end_date - NOW()))::INTEGER);
END;
$$ LANGUAGE plpgsql;

-- Function to check if subscription is expiring soon (within 7 days)
CREATE OR REPLACE FUNCTION is_clinic_subscription_expiring_soon(clinic_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  days_remaining INTEGER;
BEGIN
  days_remaining := get_clinic_subscription_days_remaining(clinic_id);
  RETURN days_remaining <= 7 AND days_remaining >= 0;
END;
$$ LANGUAGE plpgsql;
