-- Create lab_results table
-- This table stores laboratory test results

CREATE TABLE IF NOT EXISTS lab_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    test_name VARCHAR(255) NOT NULL,
    test_name_ar VARCHAR(255),
    test_category VARCHAR(100),
    test_date DATE NOT NULL,
    result_date DATE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
    results JSONB,
    normal_range TEXT,
    interpretation TEXT,
    interpretation_ar TEXT,
    notes TEXT,
    performed_by VARCHAR(255),
    lab_technician_id UUID REFERENCES users(id) ON DELETE SET NULL,
    is_abnormal BOOLEAN DEFAULT false,
    requires_follow_up BOOLEAN DEFAULT false,
    report_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_lab_results_patient_id ON lab_results(patient_id);
CREATE INDEX idx_lab_results_doctor_id ON lab_results(doctor_id);
CREATE INDEX idx_lab_results_clinic_id ON lab_results(clinic_id);
CREATE INDEX idx_lab_results_appointment_id ON lab_results(appointment_id);
CREATE INDEX idx_lab_results_test_name ON lab_results(test_name);
CREATE INDEX idx_lab_results_test_category ON lab_results(test_category);
CREATE INDEX idx_lab_results_test_date ON lab_results(test_date);
CREATE INDEX idx_lab_results_status ON lab_results(status);
CREATE INDEX idx_lab_results_is_abnormal ON lab_results(is_abnormal);
CREATE INDEX idx_lab_results_created_at ON lab_results(created_at DESC);

-- Add RLS policies
ALTER TABLE lab_results ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own lab results
CREATE POLICY "Patients can view their own lab results"
    ON lab_results FOR SELECT
    USING (
        patient_id IN (
            SELECT id FROM patients WHERE user_id = auth.uid()
        )
    );

-- Policy: Doctors can view lab results for their patients
CREATE POLICY "Doctors can view their patients lab results"
    ON lab_results FOR SELECT
    USING (
        doctor_id IN (
            SELECT id FROM doctors WHERE user_id = auth.uid()
        )
    );

-- Policy: Clinic staff can view clinic lab results
CREATE POLICY "Clinic staff can view clinic lab results"
    ON lab_results FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Lab technicians can create and update lab results
CREATE POLICY "Lab technicians can manage lab results"
    ON lab_results FOR ALL
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
            AND role IN ('lab_technician', 'doctor', 'admin', 'manager')
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_lab_results_updated_at
    BEFORE UPDATE ON lab_results
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE lab_results IS 'Laboratory test results';
COMMENT ON COLUMN lab_results.status IS 'Test status: pending, in_progress, completed, cancelled';
COMMENT ON COLUMN lab_results.results IS 'JSON object containing test results and values';
COMMENT ON COLUMN lab_results.normal_range IS 'Normal reference range for the test';
COMMENT ON COLUMN lab_results.interpretation IS 'Clinical interpretation of the results';
COMMENT ON COLUMN lab_results.is_abnormal IS 'Whether results are outside normal range';
COMMENT ON COLUMN lab_results.requires_follow_up IS 'Whether follow-up testing is required';

-- Create vital_signs table for patient vital signs
CREATE TABLE IF NOT EXISTS vital_signs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    recorded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Vital signs measurements
    temperature DECIMAL(4, 1), -- in Celsius
    temperature_unit VARCHAR(10) DEFAULT 'C',
    heart_rate INTEGER, -- beats per minute
    blood_pressure_systolic INTEGER, -- mmHg
    blood_pressure_diastolic INTEGER, -- mmHg
    respiratory_rate INTEGER, -- breaths per minute
    oxygen_saturation DECIMAL(3, 1), -- percentage
    weight DECIMAL(5, 2), -- in kg
    weight_unit VARCHAR(10) DEFAULT 'kg',
    height DECIMAL(5, 2), -- in cm
    height_unit VARCHAR(10) DEFAULT 'cm',
    bmi DECIMAL(4, 1),
    blood_glucose DECIMAL(5, 1), -- mg/dL
    blood_glucose_unit VARCHAR(10) DEFAULT 'mg/dL',
    
    notes TEXT,
    is_abnormal BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for vital_signs
CREATE INDEX idx_vital_signs_patient_id ON vital_signs(patient_id);
CREATE INDEX idx_vital_signs_doctor_id ON vital_signs(doctor_id);
CREATE INDEX idx_vital_signs_clinic_id ON vital_signs(clinic_id);
CREATE INDEX idx_vital_signs_appointment_id ON vital_signs(appointment_id);
CREATE INDEX idx_vital_signs_recorded_at ON vital_signs(recorded_at);
CREATE INDEX idx_vital_signs_is_abnormal ON vital_signs(is_abnormal);

-- Add RLS policies for vital_signs
ALTER TABLE vital_signs ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own vital signs
CREATE POLICY "Patients can view their own vital signs"
    ON vital_signs FOR SELECT
    USING (
        patient_id IN (
            SELECT id FROM patients WHERE user_id = auth.uid()
        )
    );

-- Policy: Doctors can view vital signs for their patients
CREATE POLICY "Doctors can view their patients vital signs"
    ON vital_signs FOR SELECT
    USING (
        doctor_id IN (
            SELECT id FROM doctors WHERE user_id = auth.uid()
        )
    );

-- Policy: Clinic staff can view clinic vital signs
CREATE POLICY "Clinic staff can view clinic vital signs"
    ON vital_signs FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Medical staff can create vital signs
CREATE POLICY "Medical staff can create vital signs"
    ON vital_signs FOR INSERT
    WITH CHECK (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
            AND role IN ('doctor', 'nurse', 'admin', 'manager')
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_vital_signs_updated_at
    BEFORE UPDATE ON vital_signs
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE vital_signs IS 'Patient vital signs measurements';
COMMENT ON COLUMN vital_signs.temperature IS 'Body temperature in Celsius';
COMMENT ON COLUMN vital_signs.heart_rate IS 'Heart rate in beats per minute';
COMMENT ON COLUMN vital_signs.blood_pressure_systolic IS 'Systolic blood pressure in mmHg';
COMMENT ON COLUMN vital_signs.blood_pressure_diastolic IS 'Diastolic blood pressure in mmHg';
COMMENT ON COLUMN vital_signs.respiratory_rate IS 'Respiratory rate in breaths per minute';
COMMENT ON COLUMN vital_signs.oxygen_saturation IS 'Oxygen saturation percentage';
COMMENT ON COLUMN vital_signs.blood_glucose IS 'Blood glucose level in mg/dL';