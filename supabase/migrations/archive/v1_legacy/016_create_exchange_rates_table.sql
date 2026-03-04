-- Create exchange_rates table
CREATE TABLE IF NOT EXISTS exchange_rates (
    id TEXT PRIMARY KEY,
    from_currency TEXT NOT NULL,
    to_currency TEXT NOT NULL,
    rate NUMERIC NOT NULL DEFAULT 1.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(from_currency, to_currency)
);

-- Insert default exchange rates (USD as base)
INSERT INTO exchange_rates (id, from_currency, to_currency, rate) VALUES
    ('usd_to_usd', 'USD', 'USD', 1.0),
    ('usd_to_eur', 'USD', 'EUR', 0.92),
    ('usd_to_dzd', 'USD', 'DZD', 134.5),
    ('eur_to_usd', 'EUR', 'USD', 1.09),
    ('eur_to_eur', 'EUR', 'EUR', 1.0),
    ('eur_to_dzd', 'EUR', 'DZD', 146.2),
    ('dzd_to_usd', 'DZD', 'USD', 0.0074),
    ('dzd_to_eur', 'DZD', 'EUR', 0.0068),
    ('dzd_to_dzd', 'DZD', 'DZD', 1.0)
ON CONFLICT (from_currency, to_currency) DO NOTHING;

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