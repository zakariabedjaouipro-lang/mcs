-- Migration: Create Clinic Staff Table
-- Purpose: Junction table linking clinics to staff members
-- Version: v2_P03_004
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_002_create_clinics_table.sql, v2_P03_003_create_employees_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Clinic Staff Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create clinic_staff junction table for many-to-many relationship
CREATE TABLE IF NOT EXISTS clinic_staff (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  employee_id UUID REFERENCES employees(id) ON DELETE SET NULL,

  -- Role Information
  role VARCHAR(50) NOT NULL DEFAULT 'staff' CHECK (role IN ('admin', 'manager', 'doctor', 'nurse', 'receptionist', 'staff', 'hr', 'accountant', 'lab_technician', 'radiographer', 'pharmacist')),
  
  -- Permissions
  permissions JSONB,  -- JSON object with specific permissions
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- Dates
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  left_at TIMESTAMP WITH TIME ZONE,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT unique_clinic_user UNIQUE (clinic_id, user_id)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_clinic_staff_clinic_id ON clinic_staff(clinic_id) WHERE is_active = true;
CREATE INDEX idx_clinic_staff_user_id ON clinic_staff(user_id);
CREATE INDEX idx_clinic_staff_employee_id ON clinic_staff(employee_id);
CREATE INDEX idx_clinic_staff_role ON clinic_staff(role) WHERE is_active = true;
CREATE INDEX idx_clinic_staff_is_active ON clinic_staff(is_active);
CREATE INDEX idx_clinic_staff_joined_at ON clinic_staff(joined_at);
CREATE INDEX idx_clinic_staff_left_at ON clinic_staff(left_at);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on clinic_staff table
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
      SELECT 1 FROM clinic_staff cs
      WHERE cs.clinic_id = clinic_staff.clinic_id
      AND cs.user_id = auth.uid()
      AND cs.role IN ('admin', 'manager')
    )
  );

-- Policy: Super admins can manage all clinic staff
CREATE POLICY "Super admins can manage all clinic staff"
  ON clinic_staff FOR ALL
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
CREATE OR REPLACE FUNCTION update_clinic_staff_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER clinic_staff_update_updated_at
  BEFORE UPDATE ON clinic_staff
  FOR EACH ROW
  EXECUTE FUNCTION update_clinic_staff_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE clinic_staff IS 'Junction table linking clinics to staff members';
COMMENT ON COLUMN clinic_staff.id IS 'Primary key (UUID)';
COMMENT ON COLUMN clinic_staff.clinic_id IS 'Foreign key reference to clinics table';
COMMENT ON COLUMN clinic_staff.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN clinic_staff.employee_id IS 'Foreign key reference to employees table';
COMMENT ON COLUMN clinic_staff.role IS 'Staff role in the clinic';
COMMENT ON COLUMN clinic_staff.permissions IS 'JSON object with specific permissions';
COMMENT ON COLUMN clinic_staff.joined_at IS 'Date when staff member joined the clinic';
COMMENT ON COLUMN clinic_staff.left_at IS 'Date when staff member left the clinic';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to get clinic staff count by role
CREATE OR REPLACE FUNCTION get_clinic_staff_count_by_role(clinic_id_param UUID)
RETURNS TABLE(
  role VARCHAR(50),
  count INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    role,
    COUNT(*) as count
  FROM clinic_staff
  WHERE clinic_id = clinic_id_param
    AND is_active = true
  GROUP BY role
  ORDER BY role;
END;
$$ LANGUAGE plpgsql;

-- Function to check if user is clinic admin
CREATE OR REPLACE FUNCTION is_clinic_admin(user_id_param UUID)
RETURNS BOOLEAN AS $$
DECLARE
  is_admin BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM clinic_staff
    WHERE user_id = user_id_param
    AND role IN ('admin', 'manager')
    AND is_active = true
  ) INTO is_admin;
  
  RETURN is_admin;
END;
$$ LANGUAGE plpgsql;

-- Function to get user's clinic roles
CREATE OR REPLACE FUNCTION get_user_clinic_roles(user_id_param UUID)
RETURNS TABLE(
  clinic_id UUID,
  clinic_name VARCHAR(255),
  role VARCHAR(50),
  is_active BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    cs.clinic_id,
    c.name as clinic_name,
    cs.role,
    cs.is_active
  FROM clinic_staff cs
  JOIN clinics c ON cs.clinic_id = c.id
  WHERE cs.user_id = user_id_param
  ORDER BY cs.joined_at DESC;
END;
$$ LANGUAGE plpgsql;