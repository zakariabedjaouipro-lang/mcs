-- Create patients table
-- This table stores patient-specific information

CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    date_of_birth DATE,
    gender VARCHAR(20) CHECK (gender IN ('male', 'female', 'other')),
    blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    marital_status VARCHAR(20),
    occupation VARCHAR(100),
    emergency_contact_name VARCHAR(255),
    emergency_contact_phone VARCHAR(20),
    emergency_contact_relation VARCHAR(50),
    insurance_provider VARCHAR(255),
    insurance_number VARCHAR(100),
    insurance_expiry_date DATE,
    preferred_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    preferred_doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
    medical_history TEXT[],
    allergies TEXT[],
    chronic_conditions TEXT[],
    current_medications TEXT[],
    height DECIMAL(5, 2), -- in cm
    weight DECIMAL(5, 2), -- in kg
    bmi DECIMAL(4, 1),
    smoking_status VARCHAR(20) CHECK (smoking_status IN ('never', 'former', 'current')),
    alcohol_consumption VARCHAR(20),
    physical_activity VARCHAR(50),
    dietary_restrictions TEXT[],
    profile_image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_patients_user_id ON patients(user_id);
CREATE INDEX idx_patients_preferred_clinic_id ON patients(preferred_clinic_id);
CREATE INDEX idx_patients_preferred_doctor_id ON patients(preferred_doctor_id);
CREATE INDEX idx_patients_is_active ON patients(is_active);
CREATE INDEX idx_patients_date_of_birth ON patients(date_of_birth);
CREATE INDEX idx_patients_blood_type ON patients(blood_type);
CREATE INDEX idx_patients_created_at ON patients(created_at DESC);

-- Add RLS policies
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own profile
CREATE POLICY "Patients can view their own profile"
    ON patients FOR SELECT
    USING (user_id = auth.uid());

-- Policy: Doctors can view patients they have appointments with
CREATE POLICY "Doctors can view their patients"
    ON patients FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM appointments
            WHERE appointments.patient_id = patients.id
            AND appointments.doctor_id IN (
                SELECT id FROM doctors WHERE user_id = auth.uid()
            )
        )
    );

-- Policy: Clinic staff can view patients in their clinic
CREATE POLICY "Clinic staff can view clinic patients"
    ON patients FOR SELECT
    USING (
        preferred_clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Patients can update their own profile
CREATE POLICY "Patients can update their own profile"
    ON patients FOR UPDATE
    USING (user_id = auth.uid());

-- Policy: Doctors can update patient medical information
CREATE POLICY "Doctors can update patient medical info"
    ON patients FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM appointments
            WHERE appointments.patient_id = patients.id
            AND appointments.doctor_id IN (
                SELECT id FROM doctors WHERE user_id = auth.uid()
            )
            AND appointments.status = 'completed'
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_patients_updated_at
    BEFORE UPDATE ON patients
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE patients IS 'Patient-specific medical information';
COMMENT ON COLUMN patients.blood_type IS 'Patient blood type (A+, A-, B+, B-, AB+, AB-, O+, O-)';
COMMENT ON COLUMN patients.medical_history IS 'Array of past medical conditions';
COMMENT ON COLUMN patients.allergies IS 'Array of known allergies';
COMMENT ON COLUMN patients.bmi IS 'Body Mass Index calculated from height and weight';
COMMENT ON COLUMN patients.smoking_status IS 'Patient smoking habits (never, former, current)';

-- Create function to calculate BMI
CREATE OR REPLACE FUNCTION calculate_bmi()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.height IS NOT NULL AND NEW.weight IS NOT NULL AND NEW.height > 0 THEN
        NEW.bmi = ROUND((NEW.weight / ((NEW.height / 100) * (NEW.height / 100)))::NUMERIC, 1);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for BMI calculation
CREATE TRIGGER calculate_patient_bmi
    BEFORE INSERT OR UPDATE OF height, weight ON patients
    FOR EACH ROW
    EXECUTE FUNCTION calculate_bmi();