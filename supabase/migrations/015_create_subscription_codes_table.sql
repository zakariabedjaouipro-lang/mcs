-- Create subscription_codes table
CREATE TABLE IF NOT EXISTS subscription_codes (
    id TEXT PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('trial', 'monthly', 'quarterly', 'half_yearly', 'yearly')),
    price_usd NUMERIC NOT NULL DEFAULT 0,
    price_eur NUMERIC NOT NULL DEFAULT 0,
    price_dzd NUMERIC NOT NULL DEFAULT 0,
    is_used BOOLEAN NOT NULL DEFAULT FALSE,
    clinic_id TEXT REFERENCES clinics(id) ON DELETE SET NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
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