-- Migration: Create Notification Settings Table
-- Purpose: Store user notification preferences
-- Version: v2_P07_002
-- Created: 2026-03-04
-- Dependencies: 20260304120001_create_users_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Notification Settings Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create notification_settings table to store user notification preferences
CREATE TABLE IF NOT EXISTS notification_settings (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE,

  -- Email Notifications
  email_appointments BOOLEAN NOT NULL DEFAULT true,
  email_prescriptions BOOLEAN NOT NULL DEFAULT true,
  email_lab_results BOOLEAN NOT NULL DEFAULT true,
  email_invoices BOOLEAN NOT NULL DEFAULT true,
  email_promotions BOOLEAN NOT NULL DEFAULT false,
  email_system_updates BOOLEAN NOT NULL DEFAULT true,

  -- Push Notifications
  push_appointments BOOLEAN NOT NULL DEFAULT true,
  push_prescriptions BOOLEAN NOT NULL DEFAULT true,
  push_lab_results BOOLEAN NOT NULL DEFAULT true,
  push_invoices BOOLEAN NOT NULL DEFAULT true,
  push_promotions BOOLEAN NOT NULL DEFAULT false,
  push_system_updates BOOLEAN NOT NULL DEFAULT true,

  -- SMS Notifications
  sms_appointments BOOLEAN NOT NULL DEFAULT true,
  sms_prescriptions BOOLEAN NOT NULL DEFAULT false,
  sms_lab_results BOOLEAN NOT NULL DEFAULT false,
  sms_invoices BOOLEAN NOT NULL DEFAULT false,
  sms_promotions BOOLEAN NOT NULL DEFAULT false,
  sms_system_updates BOOLEAN NOT NULL DEFAULT false,

  -- In-App Notifications
  inapp_appointments BOOLEAN NOT NULL DEFAULT true,
  inapp_prescriptions BOOLEAN NOT NULL DEFAULT true,
  inapp_lab_results BOOLEAN NOT NULL DEFAULT true,
  inapp_invoices BOOLEAN NOT NULL DEFAULT true,
  inapp_promotions BOOLEAN NOT NULL DEFAULT true,
  inapp_system_updates BOOLEAN NOT NULL DEFAULT true,

  -- Notification Timing
  quiet_hours_enabled BOOLEAN NOT NULL DEFAULT false,
  quiet_hours_start TIME,
  quiet_hours_end TIME,
  timezone VARCHAR(50) DEFAULT 'UTC',

  -- Notification Frequency
  daily_summary BOOLEAN NOT NULL DEFAULT false,
  weekly_summary BOOLEAN NOT NULL DEFAULT false,
  monthly_summary BOOLEAN NOT NULL DEFAULT false,

  -- Device Settings
  device_token VARCHAR(500),
  platform VARCHAR(50), -- ios, android, web, windows, macos
  app_version VARCHAR(50),
  last_active_at TIMESTAMP WITH TIME ZONE,

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_quiet_hours CHECK (
    NOT quiet_hours_enabled OR
    (quiet_hours_start IS NOT NULL AND quiet_hours_end IS NOT NULL)
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_notification_settings_user_id ON notification_settings(user_id);
CREATE INDEX idx_notification_settings_device_token ON notification_settings(device_token);
CREATE INDEX idx_notification_settings_platform ON notification_settings(platform);
CREATE INDEX idx_notification_settings_created_at ON notification_settings(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on notification_settings table
ALTER TABLE notification_settings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notification settings
CREATE POLICY "Users can view their own notification settings"
  ON notification_settings FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Users can create their own notification settings
CREATE POLICY "Users can create their own notification settings"
  ON notification_settings FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Policy: Users can update their own notification settings
CREATE POLICY "Users can update their own notification settings"
  ON notification_settings FOR UPDATE
  USING (user_id = auth.uid());

-- Policy: Super admins can manage all notification settings
CREATE POLICY "Super admins can manage all notification settings"
  ON notification_settings FOR ALL
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
CREATE OR REPLACE FUNCTION update_notification_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER notification_settings_update_updated_at
  BEFORE UPDATE ON notification_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_notification_settings_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE notification_settings IS 'User notification preferences';
COMMENT ON COLUMN notification_settings.id IS 'Primary key (UUID)';
COMMENT ON COLUMN notification_settings.user_id IS 'Reference to user';
COMMENT ON COLUMN notification_settings.email_appointments IS 'Email notifications for appointments';
COMMENT ON COLUMN notification_settings.push_appointments IS 'Push notifications for appointments';
COMMENT ON COLUMN notification_settings.sms_appointments IS 'SMS notifications for appointments';
COMMENT ON COLUMN notification_settings.inapp_appointments IS 'In-app notifications for appointments';
COMMENT ON COLUMN notification_settings.quiet_hours_enabled IS 'Whether quiet hours are enabled';
COMMENT ON COLUMN notification_settings.quiet_hours_start IS 'Quiet hours start time';
COMMENT ON COLUMN notification_settings.quiet_hours_end IS 'Quiet hours end time';
COMMENT ON COLUMN notification_settings.device_token IS 'FCM device token';
COMMENT ON COLUMN notification_settings.platform IS 'Device platform';