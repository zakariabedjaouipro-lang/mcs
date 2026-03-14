-- ═══════════════════════════════════════════════════════════════════════════
-- DEMO ACCOUNT SETUP SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════
--
-- This script creates demo accounts for testing and development purposes.
-- Run this AFTER the user accounts are created in Supabase Auth.
--
-- Demo Credentials:
-- - Super Admin: superadmin@demo.com / Demo@123456
-- - Admin: admin@demo.com / Demo@123456
-- - Doctor: doctor@demo.com / Demo@123456
-- - Patient: patient@demo.com / Demo@123456
-- - Employee: employee@demo.com / Demo@123456
--
-- ═══════════════════════════════════════════════════════════════════════════

-- Extend users table to allow demo accounts to be tracked
-- (This is safe even if column already exists)

-- INSERT Demo Super Admin User
INSERT INTO users (
  id,
  email,
  full_name,
  phone,
  role,
  is_active,
  locale
) VALUES (
  gen_random_uuid(),
  'superadmin@demo.com',
  'Super Administrator',
  '+213612345670',
  'super_admin',
  true,
  'ar'
) ON CONFLICT (email) DO NOTHING;

-- INSERT Demo Admin User
INSERT INTO users (
  id,
  email,
  full_name,
  phone,
  role,
  is_active,
  locale
) VALUES (
  gen_random_uuid(),
  'admin@demo.com',
  'Administrator',
  '+213612345671',
  'admin',
  true,
  'ar'
) ON CONFLICT (email) DO NOTHING;

-- INSERT Demo Doctor User
INSERT INTO users (
  id,
  email,
  full_name,
  phone,
  role,
  is_active,
  locale
) VALUES (
  gen_random_uuid(),
  'doctor@demo.com',
  'Dr. Demo Doctor',
  '+213612345672',
  'doctor',
  true,
  'ar'
) ON CONFLICT (email) DO NOTHING;

-- INSERT Demo Patient User
INSERT INTO users (
  id,
  email,
  full_name,
  phone,
  role,
  is_active,
  locale
) VALUES (
  gen_random_uuid(),
  'patient@demo.com',
  'Demo Patient',
  '+213612345673',
  'patient',
  true,
  'ar'
) ON CONFLICT (email) DO NOTHING;

-- INSERT Demo Employee User
INSERT INTO users (
  id,
  email,
  full_name,
  phone,
  role,
  is_active,
  locale
) VALUES (
  gen_random_uuid(),
  'employee@demo.com',
  'Demo Employee',
  '+213612345674',
  'employee',
  true,
  'ar'
) ON CONFLICT (email) DO NOTHING;

-- Create doctor profile for demo doctor (if doctors table exists)
DO $$
DECLARE
  demo_doctor_id UUID;
BEGIN
  SELECT id INTO demo_doctor_id FROM users WHERE email = 'doctor@demo.com';
  
  IF demo_doctor_id IS NOT NULL THEN
    INSERT INTO doctors (
      user_id,
      specialization,
      bio,
      license_number,
      years_of_experience,
      is_available,
      consultation_fee,
      created_by
    ) VALUES (
      demo_doctor_id,
      'عام',
      'طبيب تجريبي لاختبار النظام',
      'LIC-DEMO-001',
      5,
      true,
      100,
      demo_doctor_id
    ) ON CONFLICT (user_id) DO NOTHING;
  END IF;
END $$;

-- Create patient profile for demo patient (if patients table exists)
DO $$
DECLARE
  demo_patient_id UUID;
BEGIN
  SELECT id INTO demo_patient_id FROM users WHERE email = 'patient@demo.com';
  
  IF demo_patient_id IS NOT NULL THEN
    INSERT INTO patients (
      user_id,
      date_of_birth,
      gender,
      blood_type,
      allergies,
      medical_history,
      emergency_contact_name,
      emergency_contact_phone,
      created_by
    ) VALUES (
      demo_patient_id,
      '1990-01-01'::DATE,
      'M',
      'O+',
      '[]'::jsonb,
      '[]'::jsonb,
      'اسم آخر',
      '0123456789',
      demo_patient_id
    ) ON CONFLICT (user_id) DO NOTHING;
  END IF;
END $$;

-- Create employee profile for demo employee (if employees table exists)
DO $$
DECLARE
  demo_employee_id UUID;
BEGIN
  SELECT id INTO demo_employee_id FROM users WHERE email = 'employee@demo.com';
  
  IF demo_employee_id IS NOT NULL THEN
    INSERT INTO employees (
      user_id,
      position,
      department,
      hire_date,
      is_active,
      created_by
    ) VALUES (
      demo_employee_id,
      'موظف تجريبي',
      'عام',
      NOW(),
      true,
      demo_employee_id
    ) ON CONFLICT (user_id) DO NOTHING;
  END IF;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════
-- Verify Demo Accounts (SELECT for verification)
-- ═══════════════════════════════════════════════════════════════════════════

-- Run this to verify all demo accounts were created:
-- SELECT id, email, full_name, role, is_active FROM users WHERE email LIKE '%@demo.com' ORDER BY role;
