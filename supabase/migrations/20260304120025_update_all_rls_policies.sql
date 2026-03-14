-- Migration: Update All RLS Policies to Use Users Table
-- Purpose: Update all table policies to properly check user roles from users table
-- Version: v2_rls_update
-- Created: 2026-03-04
-- Dependencies: users table must exist

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Countries Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage countries" ON countries;

CREATE POLICY "Super admins can manage countries"
  ON countries FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Clinic admins can view countries"
  ON countries FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'clinic_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Regions Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage regions" ON regions;

CREATE POLICY "Super admins can manage regions"
  ON regions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Clinic admins can view regions"
  ON regions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'clinic_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Specialties Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage specialties" ON specialties;

CREATE POLICY "Super admins can manage specialties"
  ON specialties FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Clinics Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage clinics" ON clinics;

CREATE POLICY "Super admins can manage clinics"
  ON clinics FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Clinic admins can manage their clinics"
  ON clinics FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE clinic_id = clinics.id
      AND user_id = auth.uid()
      AND role IN ('clinic_admin', 'receptionist', 'nurse', 'pharmacist', 'lab_technician', 'radiographer')
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Subscriptions Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage subscriptions" ON subscriptions;

CREATE POLICY "Super admins can manage subscriptions"
  ON subscriptions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Doctors Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage doctors" ON doctors;

CREATE POLICY "Super admins can manage doctors"
  ON doctors FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Doctors can view their own profile"
  ON doctors FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Clinic admins can view their clinic's doctors"
  ON doctors FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE clinic_id = doctors.clinic_id
      AND user_id = auth.uid()
      AND role = 'clinic_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Patients Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage patients" ON patients;

CREATE POLICY "Super admins can manage patients"
  ON patients FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Patients can view their own profile"
  ON patients FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Doctors can view their patients"
  ON patients FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM doctors
      WHERE clinic_id = patients.clinic_id
      AND user_id = auth.uid()
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Employees Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage employees" ON employees;

CREATE POLICY "Super admins can manage employees"
  ON employees FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Employees can view their own profile"
  ON employees FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Clinic admins can view their clinic's employees"
  ON employees FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE clinic_id = employees.clinic_id
      AND user_id = auth.uid()
      AND role = 'clinic_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Clinic Staff Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage clinic staff" ON clinic_staff;

CREATE POLICY "Super admins can manage clinic staff"
  ON clinic_staff FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Clinic admins can manage their clinic's staff"
  ON clinic_staff FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff cs
      WHERE cs.clinic_id = clinic_staff.clinic_id
      AND cs.user_id = auth.uid()
      AND cs.role = 'clinic_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Appointments Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage appointments" ON appointments;

CREATE POLICY "Super admins can manage appointments"
  ON appointments FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Patients can view their own appointments"
  ON appointments FOR SELECT
  USING (patient_id = auth.uid());

CREATE POLICY "Doctors can view their appointments"
  ON appointments FOR SELECT
  USING (doctor_id = auth.uid());

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Prescriptions Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage prescriptions" ON prescriptions;

CREATE POLICY "Super admins can manage prescriptions"
  ON prescriptions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Patients can view their own prescriptions"
  ON prescriptions FOR SELECT
  USING (patient_id = auth.uid());

CREATE POLICY "Doctors can view prescriptions they created"
  ON prescriptions FOR SELECT
  USING (doctor_id = auth.uid());

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Lab Results Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage lab results" ON lab_results;

CREATE POLICY "Super admins can manage lab results"
  ON lab_results FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Patients can view their own lab results"
  ON lab_results FOR SELECT
  USING (patient_id = auth.uid());

CREATE POLICY "Doctors can view their patients' lab results"
  ON lab_results FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM appointments
      WHERE appointments.patient_id = lab_results.patient_id
      AND appointments.doctor_id = auth.uid()
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Video Sessions Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage video sessions" ON video_sessions;

CREATE POLICY "Super admins can manage video sessions"
  ON video_sessions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Patients can view their own video sessions"
  ON video_sessions FOR SELECT
  USING (patient_id = auth.uid());

CREATE POLICY "Doctors can view their video sessions"
  ON video_sessions FOR SELECT
  USING (doctor_id = auth.uid());

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Invoices Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage invoices" ON invoices;

CREATE POLICY "Super admins can manage invoices"
  ON invoices FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Patients can view their own invoices"
  ON invoices FOR SELECT
  USING (patient_id = auth.uid());

CREATE POLICY "Clinic admins can view their clinic's invoices"
  ON invoices FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE clinic_id = invoices.clinic_id
      AND user_id = auth.uid()
      AND role = 'clinic_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Inventory Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage inventory" ON inventory;

CREATE POLICY "Super admins can manage inventory"
  ON inventory FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Clinic admins can manage their clinic's inventory"
  ON inventory FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE clinic_id = inventory.clinic_id
      AND user_id = auth.uid()
      AND role IN ('clinic_admin', 'pharmacist')
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Notifications Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage notifications" ON notifications;

CREATE POLICY "Super admins can manage notifications"
  ON notifications FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Users can view their own notifications"
  ON notifications FOR SELECT
  USING (user_id = auth.uid());

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Subscription Codes Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage subscription codes" ON subscription_codes;

CREATE POLICY "Super admins can manage subscription codes"
  ON subscription_codes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Update Exchange Rates Policies
-- ══════════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Service role can manage exchange rates" ON exchange_rates;

CREATE POLICY "Super admins can manage exchange rates"
  ON exchange_rates FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

CREATE POLICY "Everyone can view active exchange rates"
  ON exchange_rates FOR SELECT
  USING (is_active = true);