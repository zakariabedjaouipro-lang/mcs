-- Migration: Create Patients Table
-- Purpose: Store patient-specific medical information
-- Version: v2_P03_002
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_002_create_clinics_table.sql, v2_P03_001_create_doctors_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Patients Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create patients table to store patient-specific medical information
CREATE TABLE IF NOT EXISTS patients (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  preferred_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  preferred_doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,

  -- Personal Information
  date_of_birth DATE,
  gender VARCHAR(20) CHECK (gender IN ('male', 'female', 'other')),
  blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
  marital_status VARCHAR(50),
  occupation VARCHAR(100),
  
  -- Emergency Contact
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(20),
  emergency_contact_relation VARCHAR(50),
  
  -- Insurance Information
  insurance_provider VARCHAR(255),
  insurance_number VARCHAR(100),
  insurance_expiry_date DATE,
  
  -- Medical History
  medical_history TEXT[],
  allergies TEXT[],
  chronic_conditions TEXT[],
  current_medications TEXT[],
  
  -- Physical Measurements
  height DECIMAL(5, 2),  -- in cm
  weight DECIMAL(5, 2),  -- in kg
  bmi DECIMAL(4, 1),
  
  -- Lifestyle Information
  smoking_status VARCHAR(20) CHECK (smoking_status IN ('never', 'former', 'current', 'unknown')),
  alcohol_consumption VARCHAR(50),
  physical_activity VARCHAR(50),
  dietary_restrictions TEXT[],
  
  -- Profile Media
  profile_image_url TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_height CHECK (height IS NULL OR (height > 0 AND height < 300)),
  CONSTRAINT valid_weight CHECK (weight IS NULL OR (weight > 0 AND weight < 500)),
  CONSTRAINT valid_bmi CHECK (bmi IS NULL OR (bmi > 0 AND bmi < 100))
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_patients_user_id ON patients(user_id);
CREATE INDEX idx_patients_preferred_clinic_id ON patients(preferred_clinic_id);
CREATE INDEX idx_patients_preferred_doctor_id ON patients(preferred_doctor_id);
CREATE INDEX idx_patients_is_active ON patients(is_active);
CREATE INDEX idx_patients_date_of_birth ON patients(date_of_birth);
CREATE INDEX idx_patients_blood_type ON patients(blood_type);
CREATE INDEX idx_patients_gender ON patients(gender);
CREATE INDEX idx_patients_created_at ON patients(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on patients table
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

-- Policy: Super admins can manage all patients
CREATE POLICY "Super admins can manage all patients"
  ON patients FOR ALL
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
CREATE OR REPLACE FUNCTION update_patients_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER patients_update_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW
  EXECUTE FUNCTION update_patients_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- BMI Calculation Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to calculate BMI
CREATE OR REPLACE FUNCTION calculate_patient_bmi()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.height IS NOT NULL AND NEW.weight IS NOT NULL AND NEW.height > 0 THEN
    NEW.bmi := ROUND((NEW.weight / POWER(NEW.height / 100, 2))::NUMERIC, 1);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for BMI calculation
CREATE TRIGGER calculate_patient_bmi
  BEFORE INSERT OR UPDATE OF height, weight ON patients
  FOR EACH ROW
  EXECUTE FUNCTION calculate_patient_bmi();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE patients IS 'Patient-specific medical information';
COMMENT ON COLUMN patients.id IS 'Primary key (UUID)';
COMMENT ON COLUMN patients.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN patients.preferred_clinic_id IS 'Preferred clinic ID';
COMMENT ON COLUMN patients.preferred_doctor_id IS 'Preferred doctor ID';
COMMENT ON COLUMN patients.blood_type IS 'Patient blood type (A+, A-, B+, B-, AB+, AB-, O+, O-)';
COMMENT ON COLUMN patients.medical_history IS 'Array of past medical conditions';
COMMENT ON COLUMN patients.allergies IS 'Array of known allergies';
COMMENT ON COLUMN patients.bmi IS 'Body Mass Index calculated from height and weight';
COMMENT ON COLUMN patients.smoking_status IS 'Patient smoking habits (never, former, current)';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to get patient's age
CREATE OR REPLACE FUNCTION get_patient_age(patient_id UUID)
RETURNS INTEGER AS $$
DECLARE
  date_of_birth DATE;
BEGIN
  SELECT date_of_birth INTO date_of_birth
  FROM patients
  WHERE id = patient_id;
  
  IF date_of_birth IS NULL THEN
    RETURN NULL;
  END IF;
  
  RETURN EXTRACT(YEAR FROM AGE(date_of_birth))::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- Function to get patient's full name
CREATE OR REPLACE FUNCTION get_patient_full_name(patient_id UUID)
RETURNS VARCHAR(255) AS $$
DECLARE
  full_name VARCHAR(255);
BEGIN
  SELECT COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '')
  INTO full_name
  FROM users u
  JOIN patients p ON u.id = p.user_id
  WHERE p.id = patient_id;
  
  RETURN TRIM(full_name);
END;
$$ LANGUAGE plpgsql;

-- Function to check if patient has allergies
CREATE OR REPLACE FUNCTION patient_has_allergies(patient_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  allergy_count INTEGER;
BEGIN
  SELECT cardinality(allergies) INTO allergy_count
  FROM patients
  WHERE id = patient_id;
  
  RETURN allergy_count > 0;
END;
$$ LANGUAGE plpgsql;