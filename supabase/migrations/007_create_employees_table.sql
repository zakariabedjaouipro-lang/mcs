-- Create employees table
-- This table stores employee information

CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    employee_number VARCHAR(50) UNIQUE NOT NULL,
    department VARCHAR(100),
    position VARCHAR(100),
    hire_date DATE NOT NULL,
    employment_type VARCHAR(50) DEFAULT 'full_time' CHECK (employment_type IN ('full_time', 'part_time', 'contract', 'intern')),
    salary DECIMAL(10, 2),
    salary_currency VARCHAR(3) DEFAULT 'USD',
    work_schedule JSONB,
    manager_id UUID REFERENCES employees(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT true,
    termination_date DATE,
    termination_reason TEXT,
    performance_rating DECIMAL(3, 2),
    last_performance_review DATE,
    skills TEXT[],
    certifications JSONB,
    education JSONB,
    emergency_contact_name VARCHAR(255),
    emergency_contact_phone VARCHAR(20),
    emergency_contact_relation VARCHAR(50),
    profile_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_employees_user_id ON employees(user_id);
CREATE INDEX idx_employees_clinic_id ON employees(clinic_id);
CREATE INDEX idx_employees_employee_number ON employees(employee_number);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_manager_id ON employees(manager_id);
CREATE INDEX idx_employees_is_active ON employees(is_active);
CREATE INDEX idx_employees_hire_date ON employees(hire_date);
CREATE INDEX idx_employees_created_at ON employees(created_at DESC);

-- Add RLS policies
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- Policy: Employees can view their own profile
CREATE POLICY "Employees can view their own profile"
    ON employees FOR SELECT
    USING (user_id = auth.uid());

-- Policy: Clinic staff can view employees in their clinic
CREATE POLICY "Clinic staff can view clinic employees"
    ON employees FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Managers can view their direct reports
CREATE POLICY "Managers can view their direct reports"
    ON employees FOR SELECT
    USING (
        manager_id IN (
            SELECT id FROM employees WHERE user_id = auth.uid()
        )
    );

-- Policy: Employees can update their own profile
CREATE POLICY "Employees can update their own profile"
    ON employees FOR UPDATE
    USING (user_id = auth.uid());

-- Policy: Clinic admins can update employees in their clinic
CREATE POLICY "Clinic admins can update clinic employees"
    ON employees FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM clinic_staff
            WHERE clinic_id = employees.clinic_id
            AND user_id = auth.uid()
            AND role IN ('admin', 'manager', 'hr')
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_employees_updated_at
    BEFORE UPDATE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE employees IS 'Employee information and employment details';
COMMENT ON COLUMN employees.employee_number IS 'Unique employee identification number';
COMMENT ON COLUMN employees.employment_type IS 'Type of employment: full_time, part_time, contract, intern';
COMMENT ON COLUMN employees.work_schedule IS 'JSON object containing work schedule details';
COMMENT ON COLUMN employees.performance_rating IS 'Performance rating out of 5.0';
COMMENT ON COLUMN employees.certifications IS 'JSON array of professional certifications';
COMMENT ON COLUMN employees.education IS 'JSON array of educational qualifications';

-- Create clinic_staff junction table for many-to-many relationship
CREATE TABLE IF NOT EXISTS clinic_staff (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id UUID REFERENCES clinics(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    employee_id UUID REFERENCES employees(id) ON DELETE SET NULL,
    role VARCHAR(50) DEFAULT 'staff' CHECK (role IN ('admin', 'manager', 'doctor', 'nurse', 'receptionist', 'staff', 'hr', 'accountant')),
    permissions JSONB,
    is_active BOOLEAN DEFAULT true,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for clinic_staff
CREATE INDEX idx_clinic_staff_clinic_id ON clinic_staff(clinic_id);
CREATE INDEX idx_clinic_staff_user_id ON clinic_staff(user_id);
CREATE INDEX idx_clinic_staff_employee_id ON clinic_staff(employee_id);
CREATE INDEX idx_clinic_staff_role ON clinic_staff(role);
CREATE INDEX idx_clinic_staff_is_active ON clinic_staff(is_active);

-- Add unique constraint to prevent duplicate staff assignments
CREATE UNIQUE INDEX idx_clinic_staff_unique ON clinic_staff(clinic_id, user_id);

-- Add RLS policies for clinic_staff
ALTER TABLE clinic_staff ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own clinic staff assignments
CREATE POLICY "Users can view their own staff assignments"
    ON clinic_staff FOR SELECT
    USING (user_id = auth.uid());

-- Policy: Clinic admins can view all staff in their clinic
CREATE POLICY "Clinic admins can view all clinic staff"
    ON clinic_staff FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM clinic_staff
            WHERE clinic_id = clinic_staff.clinic_id
            AND user_id = auth.uid()
            AND role IN ('admin', 'manager')
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_clinic_staff_updated_at
    BEFORE UPDATE ON clinic_staff
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comment
COMMENT ON TABLE clinic_staff IS 'Junction table linking clinics to staff members';