-- Migration: Create Vital Signs Table
-- Purpose: Store patient vital signs measurements
-- Version: v2_P04_005
-- Created: 2026-03-04
-- Dependencies: 20260304120008_create_patients_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Vital Signs Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create vital_signs table to store patient vital signs
CREATE TABLE IF NOT EXISTS vital_signs (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- Vital Signs
  -- Blood Pressure
  systolic_bp INTEGER, -- mmHg
  diastolic_bp INTEGER, -- mmHg
  bp_position VARCHAR(50), -- Sitting, standing, lying
  bp_arm VARCHAR(50), -- Left, right
  
  -- Heart Rate
  heart_rate INTEGER, -- beats per minute
  heart_rate_rhythm VARCHAR(50), -- Regular, irregular
  heart_rate_location VARCHAR(50), -- Apex, radial, etc.
  
  -- Respiratory Rate
  respiratory_rate INTEGER, -- breaths per minute
  respiratory_pattern VARCHAR(50), -- Regular, irregular, labored
  
  -- Temperature
  temperature DECIMAL(5, 2), -- Celsius
  temperature_method VARCHAR(50), -- Oral, rectal, axillary, tympanic
  temperature_unit VARCHAR(10) DEFAULT 'C',
  
  -- Oxygen Saturation
  oxygen_saturation DECIMAL(5, 2), -- SpO2 percentage
  oxygen_supplement BOOLEAN DEFAULT false,
  oxygen_flow_rate DECIMAL(5, 2), -- L/min
  oxygen_method VARCHAR(50), -- Nasal cannula, mask, etc.
  
  -- Weight
  weight DECIMAL(10, 2), -- kg
  weight_unit VARCHAR(10) DEFAULT 'kg',
  
  -- Height
  height DECIMAL(10, 2), -- cm
  height_unit VARCHAR(10) DEFAULT 'cm',
  
  -- Body Mass Index
  bmi DECIMAL(5, 2),
  
  -- Pain Assessment
  pain_score INTEGER CHECK (pain_score >= 0 AND pain_score <= 10),
  pain_scale VARCHAR(50), -- Numeric, FLACC, Wong-Baker, etc.
  pain_location TEXT,
  pain_description TEXT,
  
  -- Additional Measurements
  blood_glucose DECIMAL(5, 2), -- mg/dL
  blood_glucose_unit VARCHAR(10) DEFAULT 'mg/dL',
  blood_glucose_timing VARCHAR(50), -- Fasting, pre-meal, post-meal
  
  -- Consciousness
  consciousness_level VARCHAR(50), -- Alert, drowsy, confused, unconscious
  glasgow_coma_scale INTEGER CHECK (glasgow_coma_scale >= 3 AND glasgow_coma_scale <= 15),
  
  -- Notes
  notes TEXT,
  notes_ar TEXT,
  
  -- Abnormal Flags
  is_abnormal BOOLEAN NOT NULL DEFAULT false,
  abnormal_findings TEXT,
  
  -- System Fields
  measured_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  measured_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_bp CHECK (
    (systolic_bp IS NULL AND diastolic_bp IS NULL) OR
    (systolic_bp IS NOT NULL AND diastolic_bp IS NOT NULL AND systolic_bp > diastolic_bp)
  ),
  CONSTRAINT valid_heart_rate CHECK (heart_rate IS NULL OR heart_rate > 0),
  CONSTRAINT valid_respiratory_rate CHECK (respiratory_rate IS NULL OR respiratory_rate > 0),
  CONSTRAINT valid_temperature CHECK (temperature IS NULL OR temperature > 0),
  CONSTRAINT valid_oxygen_saturation CHECK (oxygen_saturation IS NULL OR (oxygen_saturation >= 0 AND oxygen_saturation <= 100)),
  CONSTRAINT valid_weight CHECK (weight IS NULL OR weight > 0),
  CONSTRAINT valid_height CHECK (height IS NULL OR height > 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_vital_signs_patient_id ON vital_signs(patient_id);
CREATE INDEX idx_vital_signs_appointment_id ON vital_signs(appointment_id);
CREATE INDEX idx_vital_signs_doctor_id ON vital_signs(doctor_id);
CREATE INDEX idx_vital_signs_clinic_id ON vital_signs(clinic_id);
CREATE INDEX idx_vital_signs_measured_at ON vital_signs(measured_at DESC);
CREATE INDEX idx_vital_signs_measured_by ON vital_signs(measured_by);
CREATE INDEX idx_vital_signs_is_abnormal ON vital_signs(is_abnormal);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on vital_signs table
ALTER TABLE vital_signs ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own vital signs
CREATE POLICY "Patients can view their own vital signs"
  ON vital_signs FOR SELECT
  USING (patient_id IN (
    SELECT id FROM patients WHERE user_id = auth.uid()
  ));

-- Policy: Doctors can view vital signs for their patients
CREATE POLICY "Doctors can view vital signs for their patients"
  ON vital_signs FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    ) OR
    clinic_id IN (
      SELECT clinic_id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic vital signs
CREATE POLICY "Clinic staff can view clinic vital signs"
  ON vital_signs FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors and nurses can create vital signs
CREATE POLICY "Doctors and nurses can create vital signs"
  ON vital_signs FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('doctor', 'nurse')
    )
  );

-- Policy: Doctors and nurses can update vital signs
CREATE POLICY "Doctors and nurses can update vital signs"
  ON vital_signs FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('doctor', 'nurse')
    )
  );

-- Policy: Super admins can manage all vital signs
CREATE POLICY "Super admins can manage all vital signs"
  ON vital_signs FOR ALL
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
CREATE OR REPLACE FUNCTION update_vital_signs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER vital_signs_update_updated_at
  BEFORE UPDATE ON vital_signs
  FOR EACH ROW
  EXECUTE FUNCTION update_vital_signs_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE vital_signs IS 'Patient vital signs measurements';
COMMENT ON COLUMN vital_signs.id IS 'Primary key (UUID)';
COMMENT ON COLUMN vital_signs.systolic_bp IS 'Systolic blood pressure (mmHg)';
COMMENT ON COLUMN vital_signs.diastolic_bp IS 'Diastolic blood pressure (mmHg)';
COMMENT ON COLUMN vital_signs.heart_rate IS 'Heart rate (beats per minute)';
COMMENT ON COLUMN vital_signs.respiratory_rate IS 'Respiratory rate (breaths per minute)';
COMMENT ON COLUMN vital_signs.temperature IS 'Body temperature (Celsius)';
COMMENT ON COLUMN vital_signs.oxygen_saturation IS 'Oxygen saturation (SpO2 %)';
COMMENT ON COLUMN vital_signs.weight IS 'Weight (kg)';
COMMENT ON COLUMN vital_signs.height IS 'Height (cm)';
COMMENT ON COLUMN vital_signs.bmi IS 'Body Mass Index';
COMMENT ON COLUMN vital_signs.pain_score IS 'Pain score (0-10)';
COMMENT ON COLUMN vital_signs.blood_glucose IS 'Blood glucose (mg/dL)';
COMMENT ON COLUMN vital_signs.glasgow_coma_scale IS 'Glasgow Coma Scale (3-15)';
COMMENT ON COLUMN vital_signs.is_abnormal IS 'Whether vital signs are abnormal';