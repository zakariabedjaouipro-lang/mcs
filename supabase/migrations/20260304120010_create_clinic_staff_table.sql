-- Migration: Create Clinic Staff Table
-- Purpose: Junction table linking clinics to staff members

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ═════════════════════════════════════════════
-- TABLE
-- ═════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS clinic_staff (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  employee_id UUID REFERENCES employees(id) ON DELETE SET NULL,

  role VARCHAR(50) NOT NULL DEFAULT 'staff'
    CHECK (role IN (
      'admin','manager','doctor','nurse','receptionist',
      'staff','hr','accountant','lab_technician',
      'radiographer','pharmacist'
    )),

  permissions JSONB,

  is_active BOOLEAN NOT NULL DEFAULT true,

  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  left_at TIMESTAMP WITH TIME ZONE,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT unique_clinic_user UNIQUE (clinic_id, user_id)
);

-- ═════════════════════════════════════════════
-- INDEXES
-- ═════════════════════════════════════════════

CREATE INDEX IF NOT EXISTS idx_clinic_staff_clinic_id
ON clinic_staff(clinic_id) WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_clinic_staff_user_id
ON clinic_staff(user_id);

CREATE INDEX IF NOT EXISTS idx_clinic_staff_employee_id
ON clinic_staff(employee_id);

CREATE INDEX IF NOT EXISTS idx_clinic_staff_role
ON clinic_staff(role) WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_clinic_staff_is_active
ON clinic_staff(is_active);

CREATE INDEX IF NOT EXISTS idx_clinic_staff_joined_at
ON clinic_staff(joined_at);

CREATE INDEX IF NOT EXISTS idx_clinic_staff_left_at
ON clinic_staff(left_at);

-- ═════════════════════════════════════════════
-- RLS
-- ═════════════════════════════════════════════

ALTER TABLE clinic_staff ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own staff assignments" ON clinic_staff;
CREATE POLICY "Users can view their own staff assignments"
ON clinic_staff
FOR SELECT
USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Clinic admins can view all clinic staff" ON clinic_staff;
CREATE POLICY "Clinic admins can view all clinic staff"
ON clinic_staff
FOR SELECT
USING (
  clinic_id IN (
    SELECT clinic_id
    FROM clinic_staff
    WHERE user_id = auth.uid()
    AND role IN ('admin','manager')
  )
);

DROP POLICY IF EXISTS "Super admins can manage all clinic staff" ON clinic_staff;
CREATE POLICY "Super admins can manage all clinic staff"
ON clinic_staff
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE id = auth.uid()
    AND role = 'super_admin'
  )
);

-- ═════════════════════════════════════════════
-- TRIGGER FUNCTION
-- ═════════════════════════════════════════════

CREATE OR REPLACE FUNCTION update_clinic_staff_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ═════════════════════════════════════════════
-- TRIGGER
-- ═════════════════════════════════════════════

DROP TRIGGER IF EXISTS clinic_staff_update_updated_at
ON clinic_staff;

CREATE TRIGGER clinic_staff_update_updated_at
BEFORE UPDATE ON clinic_staff
FOR EACH ROW
EXECUTE FUNCTION update_clinic_staff_updated_at();

-- ═════════════════════════════════════════════
-- COMMENTS
-- ═════════════════════════════════════════════

COMMENT ON TABLE clinic_staff IS 'Junction table linking clinics to staff members';

COMMENT ON COLUMN clinic_staff.clinic_id IS
'Reference to clinics table';

COMMENT ON COLUMN clinic_staff.user_id IS
'Reference to users table';

COMMENT ON COLUMN clinic_staff.employee_id IS
'Reference to employees table';

COMMENT ON COLUMN clinic_staff.permissions IS
'JSON object containing granular permissions';

-- ═════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ═════════════════════════════════════════════

CREATE OR REPLACE FUNCTION get_clinic_staff_count_by_role(clinic_id_param UUID)
RETURNS TABLE(role VARCHAR, count INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT role, COUNT(*)::INTEGER
  FROM clinic_staff
  WHERE clinic_id = clinic_id_param
  AND is_active = true
  GROUP BY role
  ORDER BY role;
END;
$$;

CREATE OR REPLACE FUNCTION is_clinic_admin(user_id_param UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
  is_admin BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM clinic_staff
    WHERE user_id = user_id_param
    AND role IN ('admin','manager')
    AND is_active = true
  )
  INTO is_admin;

  RETURN is_admin;
END;
$$;

CREATE OR REPLACE FUNCTION get_user_clinic_roles(user_id_param UUID)
RETURNS TABLE(
  clinic_id UUID,
  clinic_name TEXT,
  role VARCHAR,
  is_active BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    cs.clinic_id,
    c.name,
    cs.role,
    cs.is_active
  FROM clinic_staff cs
  JOIN clinics c ON cs.clinic_id = c.id
  WHERE cs.user_id = user_id_param
  ORDER BY cs.joined_at DESC;
END;
$$;
