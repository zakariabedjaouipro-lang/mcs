-- Migration: Create Doctors Table
-- Purpose: Store doctor information and profiles
-- Version: v2_P03_001
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_001_create_specialties_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Doctors Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create doctors table to store doctor information and profiles
CREATE TABLE IF NOT EXISTS doctors (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  specialty_id UUID REFERENCES specialties(id) ON DELETE SET NULL NOT NULL,

  -- Professional Information
  license_number VARCHAR(100) NOT NULL UNIQUE,
  license_expiry_date DATE,
  qualification VARCHAR(255),
  university VARCHAR(255),
  graduation_year INTEGER,
  experience_years INTEGER DEFAULT 0,
  
  -- Profile Information
  bio TEXT,
  bio_ar TEXT,
  consultation_fee DECIMAL(10, 2) DEFAULT 0.00,
  consultation_fee_currency VARCHAR(3) DEFAULT 'USD',
  
  -- Languages
  languages TEXT[] DEFAULT ARRAY[]::TEXT[],
  
  -- Availability
  is_available BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  is_accepting_new_patients BOOLEAN DEFAULT true,
  
  -- Working Hours
  working_hours JSONB,
  
  -- Ratings
  rating DECIMAL(3, 2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
  total_reviews INTEGER DEFAULT 0,
  
  -- Profile Media
  profile_image_url TEXT,
  
  -- Practice Information
  max_patients_per_day INTEGER DEFAULT 20,
  consultation_duration_minutes INTEGER DEFAULT 30,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_graduation_year CHECK (graduation_year IS NULL OR (graduation_year >= 1900 AND graduation_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 10)),
  CONSTRAINT valid_experience_years CHECK (experience_years >= 0),
  CONSTRAINT valid_consultation_fee CHECK (consultation_fee >= 0),
  CONSTRAINT valid_max_patients CHECK (max_patients_per_day > 0),
  CONSTRAINT valid_consultation_duration CHECK (consultation_duration_minutes > 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_doctors_user_id ON doctors(user_id);
CREATE INDEX idx_doctors_clinic_id ON doctors(clinic_id) WHERE is_active = true;
CREATE INDEX idx_doctors_specialty_id ON doctors(specialty_id) WHERE is_active = true;
CREATE INDEX idx_doctors_is_available ON doctors(is_available) WHERE is_active = true;
CREATE INDEX idx_doctors_is_verified ON doctors(is_verified);
CREATE INDEX idx_doctors_rating ON doctors(rating DESC) WHERE is_active = true;
CREATE INDEX idx_doctors_created_at ON doctors(created_at DESC);
CREATE INDEX idx_doctors_license_number ON doctors(license_number);
CREATE INDEX idx_doctors_is_accepting_new_patients ON doctors(is_accepting_new_patients) WHERE is_active = true;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on doctors table
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

-- Policy: Verified doctors are viewable by everyone
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

-- Policy: Super admins can manage all doctors
CREATE POLICY "Super admins can manage all doctors"
  ON doctors FOR ALL
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
CREATE OR REPLACE FUNCTION update_doctors_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER doctors_update_updated_at
  BEFORE UPDATE ON doctors
  FOR EACH ROW
  EXECUTE FUNCTION update_doctors_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE doctors IS 'Doctors information and profiles';
COMMENT ON COLUMN doctors.id IS 'Primary key (UUID)';
COMMENT ON COLUMN doctors.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN doctors.clinic_id IS 'Foreign key reference to clinics table';
COMMENT ON COLUMN doctors.specialty_id IS 'Foreign key reference to specialties table (UUID)';
COMMENT ON COLUMN doctors.license_number IS 'Medical license number';
COMMENT ON COLUMN doctors.consultation_fee IS 'Fee for consultation';
COMMENT ON COLUMN doctors.languages IS 'Array of languages spoken by the doctor';
COMMENT ON COLUMN doctors.working_hours IS 'JSON object containing working hours for each day';
COMMENT ON COLUMN doctors.max_patients_per_day IS 'Maximum number of patients the doctor can see per day';
COMMENT ON COLUMN doctors.consultation_duration_minutes IS 'Duration of consultation in minutes';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to get doctor's full name
CREATE OR REPLACE FUNCTION get_doctor_full_name(doctor_id UUID)
RETURNS VARCHAR(255) AS $$
DECLARE
  full_name VARCHAR(255);
BEGIN
  SELECT COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '')
  INTO full_name
  FROM users u
  JOIN doctors d ON u.id = d.user_id
  WHERE d.id = doctor_id;
  
  RETURN TRIM(full_name);
END;
$$ LANGUAGE plpgsql;

-- Function to check if doctor is available at a specific time
CREATE OR REPLACE FUNCTION is_doctor_available(doctor_id UUID, appointment_time TIMESTAMP WITH TIME ZONE)
RETURNS BOOLEAN AS $$
DECLARE
  working_hours JSONB;
  day_of_week TEXT;
  start_time TIME;
  end_time TIME;
  appointment_time_time TIME;
BEGIN
  -- Get working hours
  SELECT working_hours INTO working_hours
  FROM doctors
  WHERE id = doctor_id AND is_available = true;
  
  IF working_hours IS NULL THEN
    RETURN false;
  END IF;
  
  -- Get day of week (lowercase)
  day_of_week := LOWER(TO_CHAR(appointment_time, 'Day'));
  
  -- Get start and end times for that day
  start_time := (working_hours->day_of_week->>'start')::TIME;
  end_time := (working_hours->day_of_week->>'end')::TIME;
  
  IF start_time IS NULL OR end_time IS NULL THEN
    RETURN false;
  END IF;
  
  -- Get appointment time
  appointment_time_time := appointment_time::TIME;
  
  -- Check if within working hours
  RETURN appointment_time_time >= start_time AND appointment_time_time <= end_time;
END;
$$ LANGUAGE plpgsql;

-- Function to update doctor rating
CREATE OR REPLACE FUNCTION update_doctor_rating(doctor_id UUID, new_rating DECIMAL)
RETURNS VOID AS $$
DECLARE
  current_total_reviews INTEGER;
  current_avg_rating DECIMAL;
  new_total_reviews INTEGER;
  new_avg_rating DECIMAL;
BEGIN
  -- Get current stats
  SELECT total_reviews, rating INTO current_total_reviews, current_avg_rating
  FROM doctors
  WHERE id = doctor_id;
  
  -- Calculate new average
  new_total_reviews := current_total_reviews + 1;
  new_avg_rating := ((current_avg_rating * current_total_reviews) + new_rating) / new_total_reviews;
  
  -- Update doctor
  UPDATE doctors
  SET rating = ROUND(new_avg_rating::NUMERIC, 2),
      total_reviews = new_total_reviews
  WHERE id = doctor_id;
END;
$$ LANGUAGE plpgsql;