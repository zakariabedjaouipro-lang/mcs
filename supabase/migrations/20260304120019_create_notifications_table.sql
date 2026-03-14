-- Migration: Create Notifications Table
-- Purpose: Store user notifications
-- Version: v2_P07_001
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ════════════════════════════════════════════════════════════════════
-- Notifications Table
-- ════════════════════════════════════════════════════════════════

-- Create notifications table to store user notifications
CREATE TABLE IF NOT EXISTS notifications (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Notification Information
  title VARCHAR(255) NOT NULL,
  title_ar VARCHAR(255),
  body TEXT NOT NULL,
  body_ar TEXT,
  type VARCHAR(50) DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error', 'appointment', 'prescription', 'lab_result', 'invoice', 'system', 'alert')),
  
  -- Related Entity
  data JSONB,
  related_entity_type VARCHAR(50),
  related_entity_id UUID,
  
  -- Status
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP WITH TIME ZONE,
  action_url TEXT,
  action_label VARCHAR(100),
  
  -- Priority
  priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  
  -- Expiration
  expires_at TIMESTAMP WITH TIME ZONE,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ══════════════════════════════════════════════════════════════════
-- Indexes
-- ════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_related_entity ON notifications(related_entity_type, related_entity_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX idx_notifications_expires_at ON notifications(expires_at);

-- ════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════

-- Enable RLS on notifications table
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notifications
CREATE POLICY "Users can view their own notifications"
  ON notifications FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Users can update their own notifications
CREATE POLICY "Users can update their own notifications"
  ON notifications FOR UPDATE
  USING (user_id = auth.uid());

-- Policy: System can create notifications for any user
CREATE POLICY "System can create notifications"
  ON notifications FOR INSERT
  WITH CHECK (true);

-- Policy: Super admins can manage all notifications
CREATE POLICY "Super admins can manage all notifications"
  ON notifications FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════

COMMENT ON TABLE notifications IS 'User notifications';
COMMENT ON COLUMN notifications.type IS 'Notification type: info, success, warning, error, appointment, prescription, lab_result, invoice, system, alert';
COMMENT ON COLUMN notifications.data IS 'Additional data in JSON format';
COMMENT ON COLUMN notifications.related_entity_type IS 'Type of related entity (e.g., appointment, prescription)';
COMMENT ON COLUMN notifications.related_entity_id IS 'ID of related entity';
COMMENT ON COLUMN notifications.priority IS 'Notification priority: low, normal, high, urgent';

-- ════════════════════════════════════════════════════════════════
-- Notification Settings Table
-- ══════════════════════════════════════════════════════════════

-- Create notification_settings table for user notification preferences
CREATE TABLE IF NOT EXISTS notification_settings (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,

  -- Notification Preferences
  email_notifications BOOLEAN DEFAULT true,
  push_notifications BOOLEAN DEFAULT true,
  sms_notifications BOOLEAN DEFAULT false,
  appointment_reminders BOOLEAN DEFAULT true,
  prescription_alerts BOOLEAN DEFAULT true,
  lab_result_alerts BOOLEAN DEFAULT true,
  invoice_alerts BOOLEAN DEFAULT true,
  
  -- Quiet Hours
  quiet_hours_start TIME,
  quiet_hours_end TIME,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for notification_settings
CREATE INDEX idx_notification_settings_user_id ON notification_settings(user_id);

-- Add RLS policies for notification_settings
ALTER TABLE notification_settings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notification settings
CREATE POLICY "Users can view their own notification settings"
  ON notification_settings FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Users can update their own notification settings
CREATE POLICY "Users can update their own notification settings"
  ON notification_settings FOR UPDATE
  USING (user_id = auth.uid());

-- Create trigger for updated_at
CREATE TRIGGER update_notification_settings_updated_at
  BEFORE UPDATE ON notification_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_notification_settings_updated_at();

-- Add comments
COMMENT ON TABLE notification_settings IS 'User notification preferences';
COMMENT ON COLUMN notification_settings.quiet_hours_start IS 'Start time for quiet hours (no notifications)';
COMMENT ON COLUMN notification_settings.quiet_hours_end IS 'End time for quiet hours (no notifications)';

-- ════════════════════════════════════════════════════════════════
-- Autism Assessments Table
-- ════════════════════════════════════════════════════════════

-- Create autism_assessments table
CREATE TABLE IF NOT EXISTS autism_assessments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- Assessment Information
  assessment_date DATE NOT NULL,
  assessment_type VARCHAR(50),
  age_at_assessment_months INTEGER,
  
  -- Developmental Milestones
  developmental_milestones JSONB,
  behavioral_observations JSONB,
  communication_skills JSONB,
  social_interaction JSONB,
  repetitive_behaviors JSONB,
  sensory_issues JSONB,
  
  -- Clinical Information
  screening_tools JSONB,
  screening_score INTEGER,
  screening_result VARCHAR(50),
  diagnosis VARCHAR(100),
  severity_level VARCHAR(50),
  
  -- Recommendations
  recommendations TEXT[],
  follow_up_required BOOLEAN DEFAULT false,
  follow_up_date DATE,
  
  -- Parent Information
  parent_concerns TEXT,
  family_history TEXT,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for autism_assessments
CREATE INDEX idx_autism_assessments_patient_id 
ON autism_assessments(patient_id);

CREATE INDEX idx_autism_assessments_doctor_id 
ON autism_assessments(doctor_id);

CREATE INDEX idx_autism_assessments_clinic_id 
ON autism_assessments(clinic_id);

CREATE INDEX idx_autism_assessments_assessment_date 
ON autism_assessments(assessment_date);

CREATE INDEX idx_autism_assessments_diagnosis 
ON autism_assessments(diagnosis);

CREATE INDEX idx_autism_assessments_created_at 
ON autism_assessments(created_at DESC);

-- Add RLS policies for autism_assessments
ALTER TABLE autism_assessments ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own assessments
CREATE POLICY "Patients can view their own assessments"
  ON autism_assessments FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view assessments they created
CREATE POLICY "Doctors can view their assessments"
  ON autism_assessments FOR SELECT
  USING (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Clinic staff can view clinic assessments
CREATE POLICY "Clinic staff can view clinic assessments"
  ON autism_assessments FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can create assessments
CREATE POLICY "Doctors can create assessments"
  ON autism_assessments FOR INSERT
  WITH CHECK (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Doctors can update assessments
CREATE POLICY "Doctors can update assessments"
  ON autism_assessments FOR UPDATE
  USING (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Super admins can manage all assessments
CREATE POLICY "Super admins can manage all assessments"
  ON autism_assessments FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Create trigger for updated_at
CREATE TRIGGER update_autism_assessments_updated_at
  BEFORE UPDATE ON autism_assessments
  FOR EACH ROW
  EXECUTE FUNCTION update_autism_assessments_updated_at();

-- Add comments
COMMENT ON TABLE autism_assessments IS 'Autism spectrum disorder assessments';
COMMENT ON COLUMN autism_assessments.developmental_milestones IS 'JSON object containing developmental milestones assessment';
COMMENT ON COLUMN autism_assessments.behavioral_observations IS 'JSON object containing behavioral observations';
COMMENT ON COLUMN autism_assessments.screening_score IS 'Score from screening tools';
COMMENT ON COLUMN autism_assessments.diagnosis IS 'Final diagnosis if any';
COMMENT ON COLUMN autism_assessments.severity_level IS 'Severity level of diagnosis';
COMMENT ON COLUMN autism_assessments.parent_concerns IS 'Parent concerns about child development';

-- ══════════════════════════════════════════════════════════════
-- Bug Reports Table
-- ══════════════════════════════════════════════════════════════

-- Create bug_reports table
CREATE TABLE IF NOT EXISTS bug_reports (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Bug Report Information
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) CHECK (category IN ('ui', 'functionality', 'performance', 'security', 'other')),
  severity VARCHAR(20) DEFAULT 'low' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed', 'reopened')),
  
  -- Device Information
  platform VARCHAR(50),
  app_version VARCHAR(50),
  device_info JSONB,
  screenshot_url TEXT,
  
  -- Reproduction Steps
  reproduction_steps TEXT[],
  expected_behavior TEXT,
  actual_behavior TEXT,
  
  -- Assignment Information
  assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
  resolution_notes TEXT,
  resolved_at TIMESTAMP WITH TIME ZONE,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for bug_reports
CREATE INDEX idx_bug_reports_user_id ON bug_reports(user_id);
CREATE INDEX idx_bug_reports_category ON bug_reports(category);
CREATE INDEX idx_bug_reports_severity ON bug_reports(severity);
CREATE INDEX idx_bug_reports_status ON bug_reports(status);
CREATE INDEX idx_bug_reports_assigned_to ON bug_reports(assigned_to);
CREATE INDEX idx_bug_reports_created_at ON bug_reports(created_at DESC);

-- Add RLS policies for bug_reports
ALTER TABLE bug_reports ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own bug reports
CREATE POLICY "Users can view their own bug reports"
  ON bug_reports FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Admin users can view all bug reports
CREATE POLICY "Admin users can view all bug reports"
  ON bug_reports FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role IN ('admin', 'super_admin')
    )
  );

-- Policy: Users can create bug reports
CREATE POLICY "Users can create bug reports"
  ON bug_reports FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

-- Policy: Admin users can update bug reports
CREATE POLICY "Admin users can update bug reports"
  ON bug_reports FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role IN ('admin', 'super_admin')
    )
  );

-- Create trigger for updated_at
CREATE TRIGGER update_bug_reports_updated_at
  BEFORE UPDATE ON bug_reports
  FOR EACH ROW
  EXECUTE FUNCTION update_bug_reports_updated_at();

-- Add comments
COMMENT ON TABLE bug_reports IS 'Bug reports and issues';
COMMENT ON COLUMN bug_reports.category IS 'Bug category: ui, functionality, performance, security, other';
COMMENT ON COLUMN bug_reports.severity IS 'Bug severity: low, medium, high, critical';
COMMENT ON COLUMN bug_reports.status IS 'Bug status: open, in_progress, resolved, closed, reopened';
COMMENT ON COLUMN bug_reports.device_info IS 'JSON object containing device and browser information';