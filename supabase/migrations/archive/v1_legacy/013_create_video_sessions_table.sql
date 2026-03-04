-- Create video_sessions table
-- This table stores video call session information

CREATE TABLE IF NOT EXISTS video_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE CASCADE NOT NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    channel_name VARCHAR(255) NOT NULL,
    room_id VARCHAR(255) UNIQUE NOT NULL,
    token TEXT,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled', 'failed')),
    scheduled_start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    scheduled_end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    actual_start_time TIMESTAMP WITH TIME ZONE,
    actual_end_time TIMESTAMP WITH TIME ZONE,
    duration_seconds INTEGER,
    initiator_id UUID REFERENCES users(id) ON DELETE SET NULL,
    termination_reason TEXT,
    quality_rating INTEGER CHECK (quality_rating BETWEEN 1 AND 5),
    quality_feedback TEXT,
    recording_enabled BOOLEAN DEFAULT false,
    recording_url TEXT,
    screenshot_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_video_sessions_appointment_id ON video_sessions(appointment_id);
CREATE INDEX idx_video_sessions_patient_id ON video_sessions(patient_id);
CREATE INDEX idx_video_sessions_doctor_id ON video_sessions(doctor_id);
CREATE INDEX idx_video_sessions_clinic_id ON video_sessions(clinic_id);
CREATE INDEX idx_video_sessions_channel_name ON video_sessions(channel_name);
CREATE INDEX idx_video_sessions_room_id ON video_sessions(room_id);
CREATE INDEX idx_video_sessions_status ON video_sessions(status);
CREATE INDEX idx_video_sessions_scheduled_start_time ON video_sessions(scheduled_start_time);
CREATE INDEX idx_video_sessions_created_at ON video_sessions(created_at DESC);

-- Add RLS policies
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

-- Create trigger for updated_at
CREATE TRIGGER update_video_sessions_updated_at
    BEFORE UPDATE ON video_sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE video_sessions IS 'Video call session information';
COMMENT ON COLUMN video_sessions.channel_name IS 'WebRTC channel name for the video call';
COMMENT ON COLUMN video_sessions.room_id IS 'Unique room identifier for the video call';
COMMENT ON COLUMN video_sessions.status IS 'Session status: scheduled, in_progress, completed, cancelled, failed';
COMMENT ON COLUMN video_sessions.duration_seconds IS 'Actual duration of the video call in seconds';
COMMENT ON COLUMN video_sessions.quality_rating IS 'User rating of video call quality (1-5)';

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