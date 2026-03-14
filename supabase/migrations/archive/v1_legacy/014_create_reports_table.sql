-- Create reports table
-- This table stores generated reports

CREATE TABLE IF NOT EXISTS reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_name VARCHAR(255) NOT NULL,
    report_name_ar VARCHAR(255),
    report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('appointment', 'patient', 'financial', 'inventory', 'lab_result', 'staff', 'custom')),
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    generated_by UUID REFERENCES users(id) ON DELETE SET NULL,
    start_date DATE,
    end_date DATE,
    parameters JSONB,
    file_url TEXT,
    file_format VARCHAR(10) DEFAULT 'pdf' CHECK (file_format IN ('pdf', 'xlsx', 'csv', 'json')),
    file_size_bytes BIGINT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'generating', 'completed', 'failed')),
    error_message TEXT,
    record_count INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better query performance
CREATE INDEX idx_reports_clinic_id ON reports(clinic_id);
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_report_type ON reports(report_type);
CREATE INDEX idx_reports_start_date ON reports(start_date);
CREATE INDEX idx_reports_end_date ON reports(end_date);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);

-- Add RLS policies
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own reports
CREATE POLICY "Users can view their own reports"
    ON reports FOR SELECT
    USING (generated_by = auth.uid());

-- Policy: Clinic staff can view clinic reports
CREATE POLICY "Clinic staff can view clinic reports"
    ON reports FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Authorized users can create reports
CREATE POLICY "Authorized users can create reports"
    ON reports FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

-- Add comments
COMMENT ON TABLE reports IS 'Generated reports';
COMMENT ON COLUMN reports.report_type IS 'Type of report: appointment, patient, financial, inventory, lab_result, staff, custom';
COMMENT ON COLUMN reports.parameters IS 'JSON object containing report parameters';
COMMENT ON COLUMN reports.file_format IS 'Output file format: pdf, xlsx, csv, json';
COMMENT ON COLUMN reports.status IS 'Report generation status: pending, generating, completed, failed';

-- Create exchange_rates table for currency conversion
CREATE TABLE IF NOT EXISTS exchange_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    base_currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    target_currency VARCHAR(3) NOT NULL,
    rate DECIMAL(10, 6) NOT NULL,
    effective_date DATE NOT NULL,
    source VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for exchange_rates
CREATE INDEX idx_exchange_rates_base_currency ON exchange_rates(base_currency);
CREATE INDEX idx_exchange_rates_target_currency ON exchange_rates(target_currency);
CREATE INDEX idx_exchange_rates_effective_date ON exchange_rates(effective_date DESC);
CREATE INDEX idx_exchange_rates_is_active ON exchange_rates(is_active);

-- Add unique constraint
CREATE UNIQUE INDEX idx_exchange_rates_unique ON exchange_rates(base_currency, target_currency, effective_date);

-- Add RLS policies for exchange_rates
ALTER TABLE exchange_rates ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active exchange rates
CREATE POLICY "Everyone can view active exchange rates"
    ON exchange_rates FOR SELECT
    USING (is_active = true);

-- Policy: Admin users can manage exchange rates
CREATE POLICY "Admin users can manage exchange rates"
    ON exchange_rates FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role = 'super_admin'
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_exchange_rates_updated_at
    BEFORE UPDATE ON exchange_rates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE exchange_rates IS 'Currency exchange rates';
COMMENT ON COLUMN exchange_rates.rate IS 'Exchange rate from base to target currency';
COMMENT ON COLUMN exchange_rates.effective_date IS 'Date when the rate becomes effective';

-- Create autism_assessments table
CREATE TABLE IF NOT EXISTS autism_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES patients(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    assessment_date DATE NOT NULL,
    assessment_type VARCHAR(50),
    age_at_assessment_months INTEGER,
    developmental_milestones JSONB,
    behavioral_observations JSONB,
    communication_skills JSONB,
    social_interaction JSONB,
    repetitive_behaviors JSONB,
    sensory_issues JSONB,
    screening_tools JSONB,
    screening_score INTEGER,
    screening_result VARCHAR(50),
    diagnosis VARCHAR(100),
    severity_level VARCHAR(50),
    recommendations TEXT[],
    follow_up_required BOOLEAN DEFAULT false,
    follow_up_date DATE,
    parent_concerns TEXT,
    family_history TEXT,
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

-- Create trigger for updated_at
CREATE TRIGGER update_autism_assessments_updated_at
    BEFORE UPDATE ON autism_assessments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE autism_assessments IS 'Autism spectrum disorder assessments';
COMMENT ON COLUMN autism_assessments.developmental_milestones IS 'JSON object containing developmental milestones assessment';
COMMENT ON COLUMN autism_assessments.behavioral_observations IS 'JSON object containing behavioral observations';
COMMENT ON COLUMN autism_assessments.screening_score IS 'Score from screening tools';
COMMENT ON COLUMN autism_assessments.diagnosis IS 'Final diagnosis if any';
COMMENT ON COLUMN autism_assessments.severity_level IS 'Severity level of diagnosis';

-- Create bug_reports table
CREATE TABLE IF NOT EXISTS bug_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) CHECK (category IN ('ui', 'functionality', 'performance', 'security', 'other')),
    severity VARCHAR(20) DEFAULT 'low' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    platform VARCHAR(50),
    app_version VARCHAR(50),
    device_info JSONB,
    screenshot_url TEXT,
    reproduction_steps TEXT[],
    expected_behavior TEXT,
    actual_behavior TEXT,
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    resolution_notes TEXT,
    resolved_at TIMESTAMP WITH TIME ZONE,
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
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE bug_reports IS 'Bug reports and issues';
COMMENT ON COLUMN bug_reports.category IS 'Bug category: ui, functionality, performance, security, other';
COMMENT ON COLUMN bug_reports.severity IS 'Bug severity: low, medium, high, critical';
COMMENT ON COLUMN bug_reports.status IS 'Bug status: open, in_progress, resolved, closed';
COMMENT ON COLUMN bug_reports.device_info IS 'JSON object containing device and browser information';