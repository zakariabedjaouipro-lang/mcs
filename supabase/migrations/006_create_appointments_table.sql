-- Create appointments table
-- This table stores appointment information

CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE CASCADE NOT NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
    appointment_end_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show')),
    appointment_type VARCHAR(50) DEFAULT 'consultation',
    reason_for_visit TEXT,
    symptoms TEXT[],
    notes TEXT,
    diagnosis TEXT,
    prescription_id UUID REFERENCES prescriptions(id) ON DELETE SET NULL,
    follow_up_required BOOLEAN DEFAULT false,
    follow_up_date TIMESTAMP WITH TIME ZONE,
    video_call_enabled BOOLEAN DEFAULT false,
    video_call_room_id VARCHAR(255),
    video_call_started_at TIMESTAMP WITH TIME ZONE,
    video_call_ended_at TIMESTAMP WITH TIME ZONE,
    video_call_duration_seconds INTEGER,
    reminder_sent BOOLEAN DEFAULT false,
    reminder_sent_at TIMESTAMP WITH TIME ZONE,
    cancellation_reason TEXT,
    cancelled_by UUID REFERENCES users(id) ON DELETE SET NULL,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    no_show_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
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

-- Add RLS policies
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

-- Create trigger for updated_at
CREATE TRIGGER update_appointments_updated_at
    BEFORE UPDATE ON appointments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE appointments IS 'Medical appointments information';
COMMENT ON COLUMN appointments.status IS 'Appointment status: pending, confirmed, in_progress, completed, cancelled, no_show';
COMMENT ON COLUMN appointments.appointment_type IS 'Type of appointment: consultation, follow-up, emergency, video_call, etc.';
COMMENT ON COLUMN appointments.video_call_enabled IS 'Whether video call is enabled for this appointment';
COMMENT ON COLUMN appointments.video_call_room_id IS 'Room ID for video call';
COMMENT ON COLUMN appointments.follow_up_required IS 'Whether a follow-up appointment is needed';

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
        (NEW.appointment_date < appointment_end_time AND NEW.appointment_end_time > appointment_date)
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