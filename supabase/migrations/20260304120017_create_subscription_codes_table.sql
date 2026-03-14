-- Migration: Create Subscription Codes Table
-- Purpose: Store subscription codes for clinic activation
-- Version: v2_P06_001
-- Created: 2026-03-04
-- Dependencies: v2_P02_002_create_clinics_table.sql
-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;
-- ════════════════════════════════════════════════════════════════
-- Subscription Codes Table
-- ════════════════════════════════════════════════════════════

-- Create subscription_codes table to store subscription codes
CREATE TABLE IF NOT EXISTS subscription_codes (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Subscription Information
  code VARCHAR(50) NOT NULL UNIQUE NOT NULL,
  type subscription_type NOT NULL CHECK (type IN ('trial', 'monthly', 'quarterly', 'half_yearly', 'yearly')),
  
  -- Pricing (Multi-currency)
  price_usd DECIMAL(10, 2) NOT NULL DEFAULT 0,
  price_eur DECIMAL(10, 2) NOT NULL DEFAULT 0,
  price_dzd DECIMAL(10, 2) NOT NULL DEFAULT 0,
  
  -- Duration
  duration_days INTEGER NOT NULL,
  
  -- Usage Tracking
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  used_at TIMESTAMP WITH TIME ZONE,
  used_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Activation Details
  activated_at TIMESTAMP WITH TIME ZONE,
  activation_notes TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_expired BOOLEAN NOT NULL DEFAULT false,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_duration CHECK (duration_days > 0),
  CONSTRAINT valid_prices CHECK (
    price_usd >= 0 AND
    price_eur >= 0 AND
    price_dzd >= 0
  )
);

-- Create index on code for faster lookups
CREATE INDEX IF NOT EXISTS idx_subscription_codes_code ON subscription_codes(code);

-- Create index on clinic_id
CREATE INDEX IF NOT EXISTS idx_subscription_codes_clinic_id ON subscription_codes(clinic_id);

-- Create index on is_used
CREATE INDEX IF NOT EXISTS idx_subscription_codes_is_used ON subscription_codes(is_used);

-- Create index on created_at
CREATE INDEX IF NOT EXISTS idx_subscription_codes_created_at ON subscription_codes(created_at DESC);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_subscription_codes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER subscription_codes_updated_at
  BEFORE UPDATE ON subscription_codes
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_codes_updated_at();

-- Add comments
COMMENT ON TABLE subscription_codes IS 'Subscription codes for clinic activation';
COMMENT ON COLUMN subscription_codes.code IS 'Unique subscription code';
COMMENT ON COLUMN subscription_codes.type IS 'Subscription plan type';
COMMENT ON COLUMN subscription_codes.price_usd IS 'Price in US Dollars';
COMMENT ON COLUMN subscription_codes.price_eur IS 'Price in Euros';
COMMENT ON COLUMN subscription_codes.price_dzd IS 'Price in Algerian Dinars';
COMMENT ON COLUMN subscription_codes.duration_days IS 'Duration in days';