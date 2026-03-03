-- Create notifications table
-- This table stores user notifications

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    title VARCHAR(255) NOT NULL,
    title_ar VARCHAR(255),
    body TEXT NOT NULL,
    body_ar TEXT,
    type VARCHAR(50) DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error', 'appointment', 'prescription', 'lab_result', 'invoice', 'system')),
    data JSONB,
    related_entity_type VARCHAR(50),
    related_entity_id UUID,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    action_url TEXT,
    action_label VARCHAR(100),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_related_entity ON notifications(related_entity_type, related_entity_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX idx_notifications_expires_at ON notifications(expires_at);

-- Add RLS policies
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

-- Add comments
COMMENT ON TABLE notifications IS 'User notifications';
COMMENT ON COLUMN notifications.type IS 'Notification type: info, success, warning, error, appointment, prescription, lab_result, invoice, system';
COMMENT ON COLUMN notifications.data IS 'Additional data in JSON format';
COMMENT ON COLUMN notifications.related_entity_type IS 'Type of related entity (e.g., appointment, prescription)';
COMMENT ON COLUMN notifications.related_entity_id IS 'ID of related entity';
COMMENT ON COLUMN notifications.priority IS 'Notification priority: low, normal, high, urgent';

-- Create notification_settings table for user notification preferences
CREATE TABLE IF NOT EXISTS notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
    email_notifications BOOLEAN DEFAULT true,
    push_notifications BOOLEAN DEFAULT true,
    sms_notifications BOOLEAN DEFAULT false,
    appointment_reminders BOOLEAN DEFAULT true,
    prescription_alerts BOOLEAN DEFAULT true,
    lab_result_alerts BOOLEAN DEFAULT true,
    invoice_alerts BOOLEAN DEFAULT true,
    quiet_hours_start TIME,
    quiet_hours_end TIME,
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
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE notification_settings IS 'User notification preferences';
COMMENT ON COLUMN notification_settings.quiet_hours_start IS 'Start time for quiet hours (no notifications)';
COMMENT ON COLUMN notification_settings.quiet_hours_end IS 'End time for quiet hours (no notifications)';