-- Migration: Create Exchange Rates Table
-- Purpose: Store currency exchange rates
-- Version: v2_P06_002
-- Created: 2026-03-04
-- Dependencies: None

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ════════════════════════════════════════════════════════════════
-- Exchange Rates Table
-- ══════════════════════════════════════════════════════════════

-- Create exchange_rates table to store currency exchange rates
CREATE TABLE IF NOT EXISTS exchange_rates (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Currency Information
  from_currency VARCHAR(3) NOT NULL,
  to_currency VARCHAR(3) NOT NULL,
  rate DECIMAL(10, 6) NOT NULL DEFAULT 1.0,
  
  -- Date Information
  effective_date DATE NOT NULL,
  
  -- Metadata
  source VARCHAR(100),
  is_active BOOLEAN DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  UNIQUE (from_currency, to_currency, effective_date)
);

-- Create indexes for exchange_rates
CREATE INDEX idx_exchange_rates_from_currency ON exchange_rates(from_currency);
CREATE INDEX idx_exchange_rates_to_currency ON exchange_rates(to_currency);
CREATE INDEX idx_exchange_rates_effective_date ON exchange_rates(effective_date DESC);
CREATE INDEX idx_exchange_rates_is_active ON exchange_rates(is_active);

-- Add unique constraint on from_currency, to_currency, effective_date
CREATE UNIQUE INDEX idx_exchange_rates_unique ON exchange_rates(from_currency, to_currency, effective_date);

-- Insert default exchange rates (USD as base)
INSERT INTO exchange_rates (id, from_currency, to_currency, rate, effective_date) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'USD', 'USD', 1.0, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440002', 'USD', 'EUR', 0.92, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440003', 'USD', 'DZD', 134.5, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440004', 'EUR', 'USD', 1.09, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440005', 'EUR', 'EUR', 1.0, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440006', 'EUR', 'DZD', 146.2, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440007', 'DZD', 'USD', 0.0074, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440008', 'DZD', 'EUR', 0.0068, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440009', 'DZD', 'DZD', 1.0, '2026-03-04')
ON CONFLICT (from_currency, to_currency, effective_date) DO NOTHING;

-- ══════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════

-- Enable RLS on exchange_rates table
ALTER TABLE exchange_rates ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active exchange rates
CREATE POLICY "Active exchange rates are viewable by everyone"
  ON exchange_rates FOR SELECT
  USING (is_active = true);

-- Policy: Super admins can manage exchange rates
CREATE POLICY "Super admins can manage exchange rates"
  ON exchange_rates FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_exchange_rates_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exchange_rates_updated_at
  BEFORE UPDATE ON exchange_rates
  FOR EACH ROW
  EXECUTE FUNCTION update_exchange_rates_updated_at();

-- Add comments
COMMENT ON TABLE exchange_rates IS 'Currency exchange rates';
COMMENT ON COLUMN exchange_rates.rate IS 'Exchange rate from base to target currency';
COMMENT ON COLUMN exchange_rates.effective_date IS 'Date when the rate becomes effective';

-- ══════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════

-- Function to calculate exchange rate between two currencies
CREATE OR REPLACE FUNCTION calculate_exchange_rate(from_curr VARCHAR(3), to_curr VARCHAR(3))
RETURNS DECIMAL AS $$
DECLARE
  rate DECIMAL;
BEGIN
  SELECT rate INTO rate
  FROM exchange_rates
  WHERE from_currency = from_curr
    AND to_currency = to_currency
    AND is_active = true
    AND effective_date <= CURRENT_DATE
  ORDER BY effective_date DESC
  LIMIT 1;
  
  RETURN COALESCE(rate, 1.0);
END;
$$ LANGUAGE plpgsql;

-- Function to convert amount between currencies
CREATE OR REPLACE FUNCTION convert_currency(amount DECIMAL, from_curr VARCHAR(3), to_curr VARCHAR(3))
RETURNS DECIMAL AS $$
DECLARE
  rate DECIMAL;
BEGIN
  rate := calculate_exchange_rate(from_curr, to_curr);
  RETURN amount * rate;
END;
$$ LANGUAGE plpgsql;

-- Function to get all exchange rates for a base currency
CREATE OR REPLACE FUNCTION get_all_exchange_rates(base_curr VARCHAR(3))
RETURNS TABLE(
  to_currency VARCHAR(3),
  rate DECIMAL,
  effective_date DATE
) AS $$
BEGIN
  RETURN QUERY
  SELECT to_currency, rate, effective_date
  FROM exchange_rates
  WHERE from_currency = base_curr
    AND is_active = true
    AND effective_date <= CURRENT_DATE
  ORDER BY to_currency;
END;
$$ LANGUAGE plpgsql;