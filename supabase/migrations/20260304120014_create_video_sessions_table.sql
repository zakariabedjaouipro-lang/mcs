-- Migration: Create Video Sessions Table
-- Purpose: Store video call session information
-- Version: v2_P04_004
-- Created: 2026-03-04
-- Dependencies: v2_P04_001_create_appointments_table.sql, v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P02_002_create_clinics_table.sql
-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;
-- ══════════════════════════════════════════════════════════════════════════════
-- Video Sessions Table
-- ════════════════════════════════════════════════════════════════════════════

-- Create video_sessions table to store video call session information
CREATE TABLE IF NOT EXISTS video_sessions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- WebRTC Information\n  channel_name VARCHAR(255) NOT NULL,
  room_id VARCHAR(255) UNIQUE NOT NULL,
  token TEXT,

  -- Session Status
  status video_session_status DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled', 'failed', 'no_show')),
  
  -- Scheduled Times
  scheduled_start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  scheduled_end_time TIMESTAMP WITH TIME ZONE NOT NULL,
  
  -- Actual Times
  actual_start_time TIMESTAMP WITH TIME ZONE,
  actual_end_time TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,
  
  -- Session Information
  initiator_id UUID REFERENCES users(id) ON DELETE SET NULL,
  termination_reason TEXT,
  
  -- Quality Assessment
  quality_rating INTEGER CHECK (quality_rating BETWEEN 1 AND 5),
  quality_feedback TEXT,
  
  -- Recording
  recording_enabled BOOLEAN DEFAULT false,
  recording_url TEXT,
  screenshot_count INTEGER DEFAULT 0,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_scheduled_times CHECK (
    scheduled_end_time > scheduled_start_time
  ),
  CONSTRAINT valid_duration CHECK (
    duration_seconds IS NULL OR duration_seconds >= 0
  )
);

-- ════════════════════════════════════════════════════════════════════
-- Indexes
-- ════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_video_sessions_appointment_id ON video_sessions(appointment_id);
CREATE INDEX idx_video_sessions_patient_id ON video_sessions(patient_id);
CREATE INDEX idx_video_sessions_doctor_id ON video_sessions(doctor_id);
CREATE INDEX idx_video_sessions_clinic_id ON video_sessions(clinic_id);
CREATE INDEX idx_video_sessions_channel_name ON video_sessions(channel_name);
CREATE INDEX idx_video_sessions_room_id ON video_sessions(room_id);
CREATE INDEX idx_video_sessions_status ON video_sessions(status);
CREATE INDEX idx_video_sessions_scheduled_start_time ON video_sessions(scheduled_start_time);
CREATE INDEX idx_video_sessions_created_at ON video_sessions(created_at DESC);

-- ══════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════

-- Enable RLS on video_sessions table
ALTER TABLE video_sessions ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own video sessions
CREATE POLICY "Patients can view their own video sessions"
  ON video_sessions FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view their video sessions
CREATE POLICY "Doctors can view their video sessions"
  ON video_sessions FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic video sessions
CREATE POLICY "Clinic staff can view clinic video sessions"
  ON video_sessions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Authorized users can create video sessions
CREATE POLICY "Authorized users can create video sessions"
  ON video_sessions FOR INSERT
  WITH CHECK (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
    OR doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Participants can update video sessions
CREATE POLICY "Participants can update video sessions"
  ON video_sessions FOR UPDATE
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
    OR doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Super admins can manage all video sessions
CREATE POLICY "Super admins can manage all video sessions"
  ON video_sessions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════
-- Triggers
-- ════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_video_sessions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER update_video_sessions_updated_at
  BEFORE UPDATE ON video_sessions
  FOR EACH ROW
  EXECUTE FUNCTION update_video_sessions_updated_at();

-- ════════════════════════════════════════════════════════════════
-- Video Session Duration Calculation Trigger
-- ══════════════════════════════════════════════════════════════

-- Create function to calculate duration when session ends
CREATE OR REPLACE FUNCTION calculate_video_session_duration()
RETURNS TRIGGER AS $$
BEGIN
  -- Calculate duration when session status changes to completed
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    IF NEW.actual_start_time IS NOT NULL AND NEW.actual_end_time IS NOT NULL THEN
      NEW.duration_seconds := EXTRACT(EPOCH FROM (NEW.actual_end_time - NEW.actual_start_time))::INTEGER;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for calculating duration
CREATE TRIGGER calculate_video_duration_on_completion
  BEFORE UPDATE OF status, actual_start_time, actual_end_time ON video_sessions
  FOR EACH ROW
  EXECUTE FUNCTION calculate_video_session_duration();

-- ══════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════

COMMENT ON TABLE video_sessions IS 'Video call session information';
COMMENT ON COLUMN video_sessions.channel_name IS 'WebRTC channel name for the video call';
COMMENT ON COLUMN video_sessions.room_id IS 'Unique room identifier for the video call';
COMMENT ON COLUMN video_sessions.status IS 'Session status: scheduled, in_progress, completed, cancelled, failed, no_show';
COMMENT ON COLUMN video_sessions.duration_seconds IS 'Actual duration of the video call in seconds';
COMMENT ON COLUMN video_sessions.quality_rating IS 'User rating of video call quality (1-5)';

