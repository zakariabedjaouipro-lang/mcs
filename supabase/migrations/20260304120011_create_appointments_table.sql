-- Migration: Create Appointments Table
-- Purpose: Store appointment information
-- Version: v2_P04_001
-- Created: 2026-03-04
-- Dependencies: v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Appointments Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create appointments table to store appointment information
CREATE TABLE IF NOT EXISTS appointments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  prescription_id UUID REFERENCES prescriptions(id) ON DELETE SET NULL,

  -- Appointment Details
  appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
  appointment_end_time TIMESTAMP WITH TIME ZONE,
  status appointment_status DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'no_show', 'cancelled', 'rescheduled')),
  appointment_type VARCHAR(50) DEFAULT 'consultation',
  
  -- Medical Information
  reason_for_visit TEXT,
  symptoms TEXT[],
  notes TEXT,
  diagnosis TEXT,
  
  -- Follow-up
  follow_up_required BOOLEAN DEFAULT false,
  follow_up_date TIMESTAMP WITH TIME ZONE,
  
  -- Video Call
  video_call_enabled BOOLEAN DEFAULT false,
  video_call_room_id VARCHAR(255),
  video_call_started_at TIMESTAMP WITH TIME ZONE,
  video_call_ended_at TIMESTAMP WITH TIME ZONE,
  video_call_duration_seconds INTEGER,
  
  -- Reminders
  reminder_sent BOOLEAN DEFAULT false,
  reminder_sent_at TIMESTAMP WITH TIME ZONE,
  
  -- Cancellation
  cancellation_reason TEXT,
  cancelled_by UUID REFERENCES users(id) ON DELETE SET NULL,
  cancelled_at TIMESTAMP WITH TIME ZONE,
  
  -- No Show
  no_show_reason TEXT,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_appointment_dates CHECK (
    appointment_end_time IS NULL OR 
    appointment_end_time > appointment_date
  ),
  CONSTRAINT valid_video_call_duration CHECK (
    video_call_duration_seconds IS NULL OR 
    video_call_duration_seconds >= 0
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_clinic_id ON appointments(clinic_id);
CREATE INDEX idx_appointments_appointment_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_appointments_appointment_type ON appointments(appointment_type);
CREATE INDEX idx_appointments_prescription_id ON appointments(prescription_id);
CREATE INDEX idx_appointments_created_at ON appointments(created_at DESC);

-- Create composite index for doctor's schedule
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointments_patient_date ON appointments(patient_id, appointment_date);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on appointments table
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own appointments
CREATE POLICY "Patients can view their own appointments"
  ON appointments FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view their appointments
CREATE POLICY "Doctors can view their appointments"
  ON appointments FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic appointments
CREATE POLICY "Clinic staff can view clinic appointments"
  ON appointments FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Patients can create appointments
CREATE POLICY "Patients can create appointments"
  ON appointments FOR INSERT
  WITH CHECK (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can update their appointments
CREATE POLICY "Doctors can update their appointments"
  ON appointments FOR UPDATE
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Patients can cancel their own appointments
CREATE POLICY "Patients can cancel their appointments"
  ON appointments FOR UPDATE
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
    AND status IN ('pending', 'confirmed')
    AND NEW.status = 'cancelled'
  );

-- Policy: Super admins can manage all appointments
CREATE POLICY "Super admins can manage all appointments"
  ON appointments FOR ALL
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
CREATE OR REPLACE FUNCTION update_appointments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER appointments_update_updated_at
  BEFORE UPDATE ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION update_appointments_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Overlapping Appointments Prevention Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to prevent overlapping appointments
CREATE OR REPLACE FUNCTION prevent_overlapping_appointments()
RETURNS TRIGGER AS $$
DECLARE
  overlapping_count INTEGER;
BEGIN
  -- Check for overlapping appointments for the same doctor
  SELECT COUNT(*) INTO overlapping_count
  FROM appointments
  WHERE doctor_id = NEW.doctor_id
  AND id != COALESCE(NEW.id, gen_random_uuid())
  AND status NOT IN ('cancelled', 'no_show')
  AND (
    (NEW.appointment_date < COALESCE(appointment_end_time, NEW.appointment_date + INTERVAL '1 hour'))
    AND (COALESCE(NEW.appointment_end_time, NEW.appointment_date + INTERVAL '1 hour') > appointment_date)
  );

  IF overlapping_count > 0 THEN
    RAISE EXCEPTION 'Doctor has an overlapping appointment';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for preventing overlapping appointments
CREATE TRIGGER prevent_appointment_overlap
  BEFORE INSERT OR UPDATE OF appointment_date, appointment_end_time, doctor_id ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION prevent_overlapping_appointments();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appointments IS 'Medical appointments information';
COMMENT ON COLUMN appointments.status IS 'Appointment status: pending, confirmed, in_progress, completed, cancelled, no_show, rescheduled';
COMMENT ON COLUMN appointments.appointment_type IS 'Type of appointment: consultation, follow-up, emergency, video_call, etc.';
COMMENT ON COLUMN appointments.video_call_enabled IS 'Whether video call is enabled for this appointment';
COMMENT ON COLUMN appointments.video_call_room_id IS 'Room ID for video call';
COMMENT ON COLUMN appointments.follow_up_required IS 'Whether a follow-up appointment is needed';