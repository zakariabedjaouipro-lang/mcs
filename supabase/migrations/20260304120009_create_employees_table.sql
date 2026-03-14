-- Migration: Create Employees Table
-- Purpose: Store employee information and employment details
-- Version: v2_P03_003
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_002_create_clinics_table.sql

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ══════════════════════════════════════════════════════════════════════════════
-- Employees Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create employees table to store employee information and employment details
CREATE TABLE IF NOT EXISTS employees (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  manager_id UUID REFERENCES employees(id) ON DELETE SET NULL,

  -- Employee Information
  employee_number VARCHAR(50) NOT NULL UNIQUE,
  department VARCHAR(100),
  position VARCHAR(100),
  
  -- Employment Details
  hire_date DATE NOT NULL,
  employment_type VARCHAR(50) DEFAULT 'full_time' CHECK (employment_type IN ('full_time', 'part_time', 'contract', 'intern')),
  
  -- Compensation
  salary DECIMAL(10, 2),
  salary_currency VARCHAR(3) DEFAULT 'USD',
  
  -- Work Schedule
  work_schedule JSONB,
  
  -- Performance
  performance_rating DECIMAL(3, 2) CHECK (performance_rating >= 0 AND performance_rating <= 5),
  last_performance_review DATE,
  
  -- Skills and Certifications
  skills TEXT[],
  certifications JSONB,
  education JSONB,
  
  -- Emergency Contact
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(20),
  emergency_contact_relation VARCHAR(50),
  
  -- Profile Media
  profile_image_url TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  termination_date DATE,
  termination_reason TEXT,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_hire_date CHECK (hire_date <= CURRENT_DATE),
  CONSTRAINT valid_salary CHECK (salary IS NULL OR salary >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_employees_user_id ON employees(user_id);
CREATE INDEX idx_employees_clinic_id ON employees(clinic_id) WHERE is_active = true;
CREATE INDEX idx_employees_employee_number ON employees(employee_number);
CREATE INDEX idx_employees_department ON employees(department) WHERE is_active = true;
CREATE INDEX idx_employees_manager_id ON employees(manager_id);
CREATE INDEX idx_employees_is_active ON employees(is_active);
CREATE INDEX idx_employees_hire_date ON employees(hire_date);
CREATE INDEX idx_employees_created_at ON employees(created_at DESC);
CREATE INDEX idx_employees_employment_type ON employees(employment_type);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on employees table
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

-- Policy: Super admins can manage all employees
CREATE POLICY "Super admins can manage all employees"
  ON employees FOR ALL
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
CREATE OR REPLACE FUNCTION update_employees_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER employees_update_updated_at
  BEFORE UPDATE ON employees
  FOR EACH ROW
  EXECUTE FUNCTION update_employees_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE employees IS 'Employee information and employment details';
COMMENT ON COLUMN employees.id IS 'Primary key (UUID)';
COMMENT ON COLUMN employees.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN employees.clinic_id IS 'Foreign key reference to clinics table';
COMMENT ON COLUMN employees.employee_number IS 'Unique employee identification number';
COMMENT ON COLUMN employees.employment_type IS 'Type of employment: full_time, part_time, contract, intern';
COMMENT ON COLUMN employees.work_schedule IS 'JSON object containing work schedule details';
COMMENT ON COLUMN employees.performance_rating IS 'Performance rating out of 5.0';
COMMENT ON COLUMN employees.certifications IS 'JSON array of professional certifications';
COMMENT ON COLUMN employees.education IS 'JSON array of educational qualifications';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to calculate years of service
CREATE OR REPLACE FUNCTION get_years_of_service(employee_id UUID)
RETURNS INTEGER AS $$
DECLARE
  hire_date DATE;
BEGIN
  SELECT hire_date INTO hire_date
  FROM employees
  WHERE id = employee_id;
  
  IF hire_date IS NULL THEN
    RETURN 0;
  END IF;
  
  RETURN EXTRACT(YEAR FROM AGE(hire_date))::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- Function to get employee's full name
CREATE OR REPLACE FUNCTION get_employee_full_name(employee_id UUID)
RETURNS VARCHAR(255) AS $$
DECLARE
  full_name VARCHAR(255);
BEGIN
  SELECT COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '')
  INTO full_name
  FROM users u
  JOIN employees e ON u.id = e.user_id
  WHERE e.id = employee_id;
  
  RETURN TRIM(full_name);
END;
$$ LANGUAGE plpgsql;