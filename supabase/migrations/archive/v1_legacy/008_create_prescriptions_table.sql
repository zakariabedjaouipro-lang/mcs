-- Create prescriptions table
-- This table stores prescription information

CREATE TABLE IF NOT EXISTS prescriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE CASCADE NOT NULL,
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    prescription_number VARCHAR(50) UNIQUE NOT NULL,
    diagnosis TEXT,
    symptoms TEXT[],
    notes TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_prescriptions_patient_id ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_doctor_id ON prescriptions(doctor_id);
CREATE INDEX idx_prescriptions_appointment_id ON prescriptions(appointment_id);
CREATE INDEX idx_prescriptions_clinic_id ON prescriptions(clinic_id);
CREATE INDEX idx_prescriptions_prescription_number ON prescriptions(prescription_number);
CREATE INDEX idx_prescriptions_is_active ON prescriptions(is_active);
CREATE INDEX idx_prescriptions_created_at ON prescriptions(created_at DESC);

-- Add RLS policies
ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own prescriptions
CREATE POLICY "Patients can view their own prescriptions"
    ON prescriptions FOR SELECT
    USING (
        patient_id IN (
            SELECT id FROM patients WHERE user_id = auth.uid()
        )
    );

-- Policy: Doctors can view prescriptions they created
CREATE POLICY "Doctors can view their prescriptions"
    ON prescriptions FOR SELECT
    USING (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Clinic staff can view clinic prescriptions
CREATE POLICY "Clinic staff can view clinic prescriptions"
    ON prescriptions FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Doctors can create prescriptions
CREATE POLICY "Doctors can create prescriptions"
    ON prescriptions FOR INSERT
    WITH CHECK (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Doctors can update their prescriptions
CREATE POLICY "Doctors can update their prescriptions"
    ON prescriptions FOR UPDATE
    USING (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Create trigger for updated_at
CREATE TRIGGER update_prescriptions_updated_at
    BEFORE UPDATE ON prescriptions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE prescriptions IS 'Medical prescriptions information';
COMMENT ON COLUMN prescriptions.prescription_number IS 'Unique prescription identification number';

-- Create prescription_items table for individual medications
CREATE TABLE IF NOT EXISTS prescription_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    prescription_id UUID REFERENCES prescriptions(id) ON DELETE CASCADE NOT NULL,
    medication_name VARCHAR(255) NOT NULL,
    medication_name_ar VARCHAR(255),
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration VARCHAR(100) NOT NULL,
    route VARCHAR(50) DEFAULT 'oral' CHECK (route IN ('oral', 'injection', 'topical', 'inhalation', 'other')),
    instructions TEXT,
    instructions_ar TEXT,
    quantity INTEGER,
    refills_allowed INTEGER DEFAULT 0,
    refills_remaining INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for prescription_items
CREATE INDEX idx_prescription_items_prescription_id ON prescription_items(prescription_id);
CREATE INDEX idx_prescription_items_medication_name ON prescription_items(medication_name);
CREATE INDEX idx_prescription_items_is_active ON prescription_items(is_active);

-- Add RLS policies for prescription_items
ALTER TABLE prescription_items ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view prescription items through prescriptions
CREATE POLICY "Users can view prescription items via prescriptions"
    ON prescription_items FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM prescriptions p
            JOIN patients pat ON p.patient_id = pat.id
            WHERE p.id = prescription_items.prescription_id
            AND pat.user_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM prescriptions p
            JOIN doctors d ON p.doctor_id = d.id
            WHERE p.id = prescription_items.prescription_id
            AND d.user_id = auth.uid()
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_prescription_items_updated_at
    BEFORE UPDATE ON prescription_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE prescription_items IS 'Individual medications in a prescription';
COMMENT ON COLUMN prescription_items.dosage IS 'Medication dosage (e.g., 10mg, 5ml)';
COMMENT ON COLUMN prescription_items.frequency IS 'How often to take the medication (e.g., twice daily, every 8 hours)';
COMMENT ON COLUMN prescription_items.duration IS 'How long to take the medication (e.g., 7 days, 2 weeks)';
COMMENT ON COLUMN prescription_items.route IS 'Administration route: oral, injection, topical, inhalation, other';
COMMENT ON COLUMN prescription_items.refills_allowed IS 'Number of refills allowed for this medication';
COMMENT ON COLUMN prescription_items.refills_remaining IS 'Number of refills remaining';