-- Migration: Create Subscriptions Table
-- Purpose: Store clinic subscription information
-- Version: v2_P02_003
-- Created: 2026-03-04
-- Dependencies: None

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ══════════════════════════════════════════════════════════════════════════════
-- Subscriptions Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create subscriptions table to store clinic subscription information
CREATE TABLE IF NOT EXISTS subscriptions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Subscription Information
  code VARCHAR(50) NOT NULL UNIQUE,  -- Unique subscription code
  type subscription_type NOT NULL,
  
  -- Pricing (Multi-currency)
  price_usd DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  price_eur DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  price_dzd DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  
  -- Duration
  duration_days INTEGER NOT NULL,
  
  -- Usage Tracking
  is_used BOOLEAN NOT NULL DEFAULT false,
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
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_duration CHECK (duration_days > 0),
  CONSTRAINT valid_price_usd CHECK (price_usd >= 0),
  CONSTRAINT valid_price_eur CHECK (price_eur >= 0),
  CONSTRAINT valid_price_dzd CHECK (price_dzd >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_subscriptions_code ON subscriptions(code);
CREATE INDEX idx_subscriptions_type ON subscriptions(type);
CREATE INDEX idx_subscriptions_clinic_id ON subscriptions(clinic_id);
CREATE INDEX idx_subscriptions_is_used ON subscriptions(is_used);
CREATE INDEX idx_subscriptions_is_active ON subscriptions(is_active);
CREATE INDEX idx_subscriptions_is_expired ON subscriptions(is_expired);
CREATE INDEX idx_subscriptions_created_at ON subscriptions(created_at DESC);
CREATE INDEX idx_subscriptions_used_at ON subscriptions(used_at);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on subscriptions table
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Policy: Super admins can manage all subscriptions
CREATE POLICY "Super admins can manage all subscriptions"
  ON subscriptions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Policy: Clinic admins can view their clinic subscriptions
CREATE POLICY "Clinic admins can view their clinic subscriptions"
  ON subscriptions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM users WHERE id = auth.uid()
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_subscriptions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER subscriptions_update_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_subscriptions_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE subscriptions IS 'Clinic subscription information';
COMMENT ON COLUMN subscriptions.id IS 'Primary key (UUID)';
COMMENT ON COLUMN subscriptions.code IS 'Unique subscription code';
COMMENT ON COLUMN subscriptions.type IS 'Type of subscription plan';
COMMENT ON COLUMN subscriptions.price_usd IS 'Price in US Dollars';
COMMENT ON COLUMN subscriptions.price_eur IS 'Price in Euros';
COMMENT ON COLUMN subscriptions.price_dzd IS 'Price in Algerian Dinars';
COMMENT ON COLUMN subscriptions.duration_days IS 'Duration in days';
COMMENT ON COLUMN subscriptions.is_used IS 'Whether the subscription code has been used';
COMMENT ON COLUMN subscriptions.clinic_id IS 'Foreign key reference to clinics table';
COMMENT ON COLUMN subscriptions.used_at IS 'Timestamp when the subscription was used';
COMMENT ON COLUMN subscriptions.is_active IS 'Whether the subscription is active';
COMMENT ON COLUMN subscriptions.is_expired IS 'Whether the subscription has expired';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Drop any conflicting functions from clinics migration
DROP FUNCTION IF EXISTS is_subscription_expired(UUID) CASCADE;
DROP FUNCTION IF EXISTS get_subscription_days_remaining(UUID) CASCADE;

-- Function to calculate subscription end date
CREATE OR REPLACE FUNCTION get_subscription_end_date(subscription_id UUID)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
  activation_date TIMESTAMP WITH TIME ZONE;
  duration_days INTEGER;
BEGIN
  SELECT activated_at, duration_days INTO activation_date, duration_days
  FROM subscriptions
  WHERE id = subscription_id;
  
  IF activation_date IS NULL OR duration_days IS NULL THEN
    RETURN NULL;
  END IF;
  
  RETURN activation_date + (duration_days || ' days')::INTERVAL;
END;
$$ LANGUAGE plpgsql;

-- Function to check if subscription is expired
CREATE OR REPLACE FUNCTION is_subscription_expired(subscription_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  end_date := get_subscription_end_date(subscription_id);
  
  IF end_date IS NULL THEN
    RETURN false;
  END IF;
  
  RETURN end_date < NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to get days remaining in subscription
CREATE OR REPLACE FUNCTION get_subscription_days_remaining(subscription_id UUID)
RETURNS INTEGER AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  end_date := get_subscription_end_date(subscription_id);
  
  IF end_date IS NULL THEN
    RETURN 0;
  END IF;
  
  RETURN GREATEST(0, EXTRACT(DAY FROM (end_date - NOW()))::INTEGER);
END;
$$ LANGUAGE plpgsql;

-- Function to mark expired subscriptions
CREATE OR REPLACE FUNCTION mark_expired_subscriptions()
RETURNS INTEGER AS $$
DECLARE
  expired_count INTEGER := 0;
BEGIN
  UPDATE subscriptions
  SET is_expired = true,
      updated_at = NOW()
  WHERE is_active = true
    AND is_used = true
    AND activated_at IS NOT NULL
    AND activated_at + (duration_days || ' days')::INTERVAL < NOW();
  
  GET DIAGNOSTICS expired_count = ROW_COUNT;
  
  RETURN expired_count;
END;
$$ LANGUAGE plpgsql;