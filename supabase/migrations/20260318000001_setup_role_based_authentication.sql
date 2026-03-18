-- Migration: Setup Role-Based Authentication System
-- Purpose: Create tables for roles, permissions, and registration requests
-- Version: v1_role_authentication
-- Created: 2026-03-18

-- ══════════════════════════════════════════════════════════════════════════════
-- Roles Table
-- ══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) UNIQUE NOT NULL,
  display_name_ar TEXT NOT NULL,
  display_name_en TEXT NOT NULL,
  description TEXT,
  description_en TEXT,
  requires_approval BOOLEAN DEFAULT false,
  requires_2fa BOOLEAN DEFAULT false,
  requires_email_verification BOOLEAN DEFAULT true,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments
COMMENT ON TABLE roles IS 'User roles and their authentication requirements';
COMMENT ON COLUMN roles.name IS 'Unique role identifier (e.g., admin, doctor, patient)';
COMMENT ON COLUMN roles.requires_approval IS 'Whether registration requires admin approval';
COMMENT ON COLUMN roles.requires_2fa IS 'Whether this role requires two-factor authentication';

-- Create indexes for roles
CREATE INDEX idx_roles_name ON roles(name);
CREATE INDEX idx_roles_is_active ON roles(is_active);

-- ══════════════════════════════════════════════════════════════════════════════
-- Role Permissions Table
-- ══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS role_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_key VARCHAR(100) NOT NULL,
  is_allowed BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(role_id, permission_key),
  UNIQUE(role_id, permission_key)
);

-- Add comments
COMMENT ON TABLE role_permissions IS 'Permissions allowed for each role';
COMMENT ON COLUMN role_permissions.permission_key IS 'Permission identifier (e.g., patients.create, appointments.view_all)';

-- Create indexes
CREATE INDEX idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX idx_role_permissions_permission_key ON role_permissions(permission_key);
CREATE INDEX idx_role_permissions_is_allowed ON role_permissions(is_allowed);

-- ══════════════════════════════════════════════════════════════════════════════
-- Registration Requests Table
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS registration_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role_id UUID NOT NULL REFERENCES roles(id) ON DELETE RESTRICT,
  status VARCHAR(20) DEFAULT 'pending',
  requested_data JSONB,
  reviewed_by UUID REFERENCES auth.users(id),
  reviewed_at TIMESTAMP WITH TIME ZONE,
  rejection_reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT valid_status CHECK (status IN ('pending', 'approved', 'rejected', 'under_review'))
);

-- Add comments
COMMENT ON TABLE registration_requests IS 'Registration requests for roles requiring approval';
COMMENT ON COLUMN registration_requests.status IS 'Current status: pending, approved, rejected, under_review';
COMMENT ON COLUMN registration_requests.requested_data IS 'Additional data submitted with the registration (e.g., license number for doctors)';

-- Create indexes
CREATE INDEX idx_registration_requests_user_id ON registration_requests(user_id);
CREATE INDEX idx_registration_requests_role_id ON registration_requests(role_id);
CREATE INDEX idx_registration_requests_status ON registration_requests(status);
CREATE INDEX idx_registration_requests_reviewed_by ON registration_requests(reviewed_by);
CREATE INDEX idx_registration_requests_created_at ON registration_requests(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Extend Profiles/Users Table with Authentication Fields
-- ══════════════════════════════════════════════════════════════════════════════

ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS role_id UUID REFERENCES roles(id);
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS is_2fa_enabled BOOLEAN DEFAULT false;
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS phone_verified_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS registration_status VARCHAR(20) DEFAULT 'active';
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS approval_notes TEXT;
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS locked_until TIMESTAMP WITH TIME ZONE;
ALTER TABLE IF EXISTS profiles ADD COLUMN IF NOT EXISTS login_attempts INTEGER DEFAULT 0;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on roles table
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;

-- Everyone can view roles
CREATE POLICY "Anyone can view roles"
  ON roles FOR SELECT
  USING (is_active = true);

-- Only super admins can modify roles
CREATE POLICY "Super admins can manage roles"
  ON roles FOR ALL
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users
      WHERE raw_user_meta_data->>'role' = 'super_admin'
    )
  );

-- Enable RLS on role_permissions table
ALTER TABLE role_permissions ENABLE ROW LEVEL SECURITY;

-- Anyone can view permissions for active roles
CREATE POLICY "Anyone can view active role permissions"
  ON role_permissions FOR SELECT
  USING (
    role_id IN (SELECT id FROM roles WHERE is_active = true)
  );

-- Only super admins can modify permissions
CREATE POLICY "Super admins can manage permissions"
  ON role_permissions FOR ALL
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users
      WHERE raw_user_meta_data->>'role' = 'super_admin'
    )
  );

-- Enable RLS on registration_requests table
ALTER TABLE registration_requests ENABLE ROW LEVEL SECURITY;

-- Users can view their own registration requests
CREATE POLICY "Users can view their own requests"
  ON registration_requests FOR SELECT
  USING (user_id = auth.uid());

-- Admins can view all registration requests
CREATE POLICY "Admins can view all registration requests"
  ON registration_requests FOR SELECT
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users
      WHERE raw_user_meta_data->>'role' IN ('super_admin', 'admin')
    )
  );

-- Only admins can update registration requests
CREATE POLICY "Admins can update registration requests"
  ON registration_requests FOR UPDATE
  USING (
    auth.uid() IN (
      SELECT id FROM auth.users
      WHERE raw_user_meta_data->>'role' IN ('super_admin', 'admin')
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Predefined Roles Data
-- ══════════════════════════════════════════════════════════════════════════════

-- Insert default roles (only if they don't exist)
INSERT INTO roles (name, display_name_ar, display_name_en, requires_approval, requires_2fa, requires_email_verification, description, description_en)
VALUES
  ('super_admin', 'مسؤول العام', 'Super Admin', true, true, true, 'مسؤول النظام الكامل', 'Full system administrator'),
  ('admin', 'مسؤول', 'Admin', true, true, true, 'مسؤول في العيادة', 'Clinic administrator'),
  ('doctor', 'طبيب', 'Doctor', true, false, true, 'طبيب مسجل', 'Registered doctor'),
  ('receptionist', 'موظف استقبال', 'Receptionist', false, false, true, 'موظف استقبال', 'Reception staff'),
  ('nurse', 'ممرضة', 'Nurse', false, false, true, 'ممرضة مسجلة', 'Registered nurse'),
  ('lab_technician', 'فني مختبر', 'Lab Technician', false, false, true, 'فني مختبر', 'Laboratory technician'),
  ('pharmacist', 'صيدلاني', 'Pharmacist', false, false, true, 'صيدلاني مسجل', 'Registered pharmacist'),
  ('patient', 'مريض', 'Patient', false, false, true, 'مريض مسجل', 'Registered patient')
ON CONFLICT (name) DO NOTHING;

-- ══════════════════════════════════════════════════════════════════════════════
-- Insert Default Permissions for Each Role
-- ══════════════════════════════════════════════════════════════════════════════

-- Permissions for patients
INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'patients.view_profile', true FROM roles WHERE name = 'patient'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'patients.edit_profile', true FROM roles WHERE name = 'patient'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'patients.view_appointments', true FROM roles WHERE name = 'patient'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'patients.create_appointments', true FROM roles WHERE name = 'patient'
ON CONFLICT (role_id, permission_key) DO NOTHING;

-- Permissions for doctors
INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'doctors.view_profile', true FROM roles WHERE name = 'doctor'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'doctors.view_appointments', true FROM roles WHERE name = 'doctor'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'doctors.create_prescriptions', true FROM roles WHERE name = 'doctor'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'doctors.view_patients', true FROM roles WHERE name = 'doctor'
ON CONFLICT (role_id, permission_key) DO NOTHING;

-- Permissions for admins
INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'admin.view_all_patients', true FROM roles WHERE name = 'admin'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'admin.approve_requests', true FROM roles WHERE name = 'admin'
ON CONFLICT (role_id, permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'admin.view_analytics', true FROM roles WHERE name = 'admin'
ON CONFLICT (role_id, permission_key) DO NOTHING;

-- Permissions for super admins (all permissions)
INSERT INTO role_permissions (role_id, permission_key, is_allowed)
SELECT id, 'super_admin.full_access', true FROM roles WHERE name = 'super_admin'
ON CONFLICT (role_id, permission_key) DO NOTHING;

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers for Update Timestamps
-- ══════════════════════════════════════════════════════════════════════════════

-- Trigger for roles table
CREATE OR REPLACE FUNCTION update_roles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER roles_update_updated_at
  BEFORE UPDATE ON roles
  FOR EACH ROW
  EXECUTE FUNCTION update_roles_updated_at();

-- Trigger for registration_requests table
CREATE OR REPLACE FUNCTION update_registration_requests_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER registration_requests_update_updated_at
  BEFORE UPDATE ON registration_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_registration_requests_updated_at();
