-- Create doctors table
-- This table stores information about doctors

CREATE TABLE IF NOT EXISTS doctors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    specialty_id UUID REFERENCES specialties(id) ON DELETE SET NULL,
    license_number VARCHAR(100) UNIQUE NOT NULL,
    license_expiry_date DATE,
    qualification VARCHAR(255),
    university VARCHAR(255),
    graduation_year INTEGER,
    experience_years INTEGER DEFAULT 0,
    bio TEXT,
    bio_ar TEXT,
    consultation_fee DECIMAL(10, 2) DEFAULT 0.00,
    consultation_fee_currency VARCHAR(3) DEFAULT 'USD',
    languages TEXT[] DEFAULT ARRAY[]::TEXT[],
    is_available BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INTEGER DEFAULT 0,
    profile_image_url TEXT,
    working_hours JSONB,
    max_patients_per_day INTEGER DEFAULT 20,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_doctors_user_id ON doctors(user_id);
CREATE INDEX idx_doctors_clinic_id ON doctors(clinic_id);
CREATE INDEX idx_doctors_specialty_id ON doctors(specialty_id);
CREATE INDEX idx_doctors_is_available ON doctors(is_available);
CREATE INDEX idx_doctors_is_verified ON doctors(is_verified);
CREATE INDEX idx_doctors_rating ON doctors(rating DESC);
CREATE INDEX idx_doctors_created_at ON doctors(created_at DESC);

-- Add unique constraint for license_number
ALTER TABLE doctors ADD CONSTRAINT doctors_license_number_key UNIQUE (license_number);

-- Add RLS policies
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view verified doctors
CREATE POLICY "Verified doctors are viewable by everyone"
    ON doctors FOR SELECT
    USING (is_verified = true);

-- Policy: Doctors can view their own profile
CREATE POLICY "Doctors can view their own profile"
    ON doctors FOR SELECT
    USING (user_id = auth.uid());

-- Policy: Clinic staff can view doctors in their clinic
CREATE POLICY "Clinic staff can view clinic doctors"
    ON doctors FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Doctors can update their own profile
CREATE POLICY "Doctors can update their own profile"
    ON doctors FOR UPDATE
    USING (user_id = auth.uid());

-- Policy: Clinic admins can update doctors in their clinic
CREATE POLICY "Clinic admins can update clinic doctors"
    ON doctors FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM clinic_staff
            WHERE clinic_id = doctors.clinic_id
            AND user_id = auth.uid()
            AND role IN ('admin', 'manager')
        )
    );

-- Policy: Authenticated users can create doctors
CREATE POLICY "Authenticated users can create doctors"
    ON doctors FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

-- Create trigger for updated_at
CREATE TRIGGER update_doctors_updated_at
    BEFORE UPDATE ON doctors
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE doctors IS 'Doctors information and profiles';
COMMENT ON COLUMN doctors.license_number IS 'Medical license number';
COMMENT ON COLUMN doctors.consultation_fee IS 'Fee for consultation';
COMMENT ON COLUMN doctors.languages IS 'Array of languages spoken by the doctor';
COMMENT ON COLUMN doctors.working_hours IS 'JSON object containing working hours for each day';
COMMENT ON COLUMN doctors.max_patients_per_day IS 'Maximum number of patients the doctor can see per day';