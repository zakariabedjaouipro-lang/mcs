-- Create clinics table
-- This table stores information about medical clinics

CREATE TABLE IF NOT EXISTS clinics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    description_ar TEXT,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
    country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    website VARCHAR(255),
    logo_url TEXT,
    opening_hours JSONB,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
    subscription_expiry_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_clinics_region_id ON clinics(region_id);
CREATE INDEX idx_clinics_country_id ON clinics(country_id);
CREATE INDEX idx_clinics_subscription_id ON clinics(subscription_id);
CREATE INDEX idx_clinics_is_active ON clinics(is_active);
CREATE INDEX idx_clinics_is_verified ON clinics(is_verified);
CREATE INDEX idx_clinics_created_at ON clinics(created_at DESC);

-- Add RLS policies
ALTER TABLE clinics ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view active clinics
CREATE POLICY "Active clinics are viewable by everyone"
    ON clinics FOR SELECT
    USING (is_active = true);

-- Policy: Clinic owners can view their own clinic
CREATE POLICY "Clinic owners can view their clinic"
    ON clinics FOR SELECT
    USING (
        created_by = auth.uid()
        OR EXISTS (
            SELECT 1 FROM clinic_staff
            WHERE clinic_id = clinics.id
            AND user_id = auth.uid()
        )
    );

-- Policy: Clinic owners can update their clinic
CREATE POLICY "Clinic owners can update their clinic"
    ON clinics FOR UPDATE
    USING (
        created_by = auth.uid()
        OR EXISTS (
            SELECT 1 FROM clinic_staff
            WHERE clinic_id = clinics.id
            AND user_id = auth.uid()
            AND role IN ('admin', 'manager')
        )
    );

-- Policy: Clinic owners can delete their clinic
CREATE POLICY "Clinic owners can delete their clinic"
    ON clinics FOR DELETE
    USING (created_by = auth.uid());

-- Policy: Authenticated users can create clinics
CREATE POLICY "Authenticated users can create clinics"
    ON clinics FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

-- Create trigger for updated_at
CREATE TRIGGER update_clinics_updated_at
    BEFORE UPDATE ON clinics
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comment
COMMENT ON TABLE clinics IS 'Medical clinics information';
COMMENT ON COLUMN clinics.opening_hours IS 'JSON object containing opening hours for each day of the week';
COMMENT ON COLUMN clinics.latitude IS 'Geographic latitude for map display';
COMMENT ON COLUMN clinics.longitude IS 'Geographic longitude for map display';