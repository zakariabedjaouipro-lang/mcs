-- Migration: Create Enums for MCS Database
-- Purpose: Define PostgreSQL enum types used throughout the application
-- Created: 2026-03-02

-- ══════════════════════════════════════════════════════════════════════════════
-- User and Auth Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- User role enumeration
-- Defines different roles in the clinic system
CREATE TYPE user_role AS ENUM (
  'super_admin',         -- Platform administrator
  'clinic_admin',        -- Clinic manager/administrator
  'doctor',              -- Medical doctor/physician
  'nurse',               -- Nursing staff
  'receptionist',        -- Reception/front desk
  'pharmacist',          -- Pharmacy staff
  'lab_technician',      -- Laboratory technician
  'radiographer',        -- X-ray/imaging technician
  'patient',             -- Patient/client
  'relative'             -- Family member of patient
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Appointment and Medical Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Appointment status enumeration
-- Tracks the lifecycle of appointments
CREATE TYPE appointment_status AS ENUM (
  'pending',             -- Waiting for confirmation
  'confirmed',           -- Appointment confirmed
  'in_progress',         -- Currently in consultation
  'completed',           -- Appointment finished
  'no_show',             -- Patient didn't show up
  'cancelled',           -- Cancelled by clinic or patient
  'rescheduled'          -- Moved to different time
);

-- Invoice status enumeration
-- Tracks payment status throughout the lifecycle
CREATE TYPE invoice_status AS ENUM (
  'draft',               -- Not yet issued
  'issued',              -- Sent to patient
  'pending',             -- Awaiting payment
  'paid',                -- Payment received
  'overdue',             -- Payment past due date
  'cancelled',           -- Transaction cancelled
  'refunded'             -- Partially or fully refunded
);

-- Subscription type enumeration
-- Defines different service subscription plans
CREATE TYPE subscription_type AS ENUM (
  'free',                -- No subscription
  'basic',               -- Basic plan
  'professional',        -- Professional plan
  'enterprise',          -- Enterprise plan
  'custom',              -- Custom arrangement
  'trial'                -- Trial period
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Video Session Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Video session status enumeration
-- Tracks telemedicine session states
CREATE TYPE video_session_status AS ENUM (
  'scheduled',           -- Upcoming video call
  'active',              -- Currently in progress
  'completed',           -- Session finished
  'cancelled',           -- Session was cancelled
  'no_show'              -- Participant didn't show up
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Notification Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Notification type enumeration
-- Categorizes different types of notifications
CREATE TYPE notification_type AS ENUM (
  'appointment',         -- Appointment-related notification
  'prescription',        -- Prescription-related notification
  'payment',             -- Payment/invoice notification
  'message',             -- Direct message from clinic staff
  'system',              -- System notifications
  'alert'                -- Critical alerts
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Medical and Health Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Blood pressure status enumeration
-- Classification based on systolic/diastolic readings
CREATE TYPE blood_pressure_status AS ENUM (
  'normal',              -- < 120/80 mmHg
  'elevated',            -- 120-129 / < 80 mmHg
  'high_stage_1',        -- 130-139 / 80-89 mmHg
  'high_stage_2',        -- >= 140 / >= 90 mmHg
  'hypertensive_crisis', -- > 180 / > 120 mmHg
  'low'                  -- Hypotension
);

-- Temperature status enumeration
-- Classification of body temperature readings
CREATE TYPE temperature_status AS ENUM (
  'normal',              -- 36.1 - 37.5°C
  'low',                 -- < 36.1°C (hypothermia)
  'fever',               -- 38.0 - 38.9°C
  'high_fever',          -- >= 39.0°C
  'critical'             -- >= 40.5°C
);

-- Lab result type enumeration
-- Categorizes different medical tests
CREATE TYPE lab_result_type AS ENUM (
  'blood_test',          -- Blood work/hematology
  'urine_test',          -- Urinalysis
  'culture',             -- Bacterial/fungal culture
  'pathology',           -- Tissue analysis
  'allergy_test',        -- Allergy testing
  'genetic_test',        -- Genetic screening
  'covid_test',          -- COVID-19 test
  'other'                -- Miscellaneous tests
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Report and Assessment Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Assessment type enumeration
-- Categorizes different types of clinical assessments
CREATE TYPE assessment_type AS ENUM (
  'autism_ados1',        -- Autism Diagnostic Observation Schedule Module 1
  'autism_ados2',        -- Autism Diagnostic Observation Schedule Module 2
  'autism_cars',         -- Childhood Autism Rating Scale
  'autism_m_chat',       -- Modified Checklist for Autism in Toddlers
  'autism_aapep',        -- Adolescent and Adult Psychoeducational Profile
  'psychiatric',         -- Psychiatric evaluation
  'psychological',       -- Psychological assessment
  'neurological',        -- Neurological examination
  'developmental',       -- Developmental screening
  'other'                -- Other assessment types
);

-- Bug report status enumeration
-- Tracks bug report lifecycle
CREATE TYPE bug_report_status AS ENUM (
  'new',                 -- Newly reported
  'in_progress',         -- Developer is working on it
  'resolved',            -- Fix implemented
  'closed',              -- Report closed (with/without fix)
  'reopened'             -- Previously closed issue reopened
);

-- Employee type enumeration
-- Categorizes clinic staff positions
CREATE TYPE employee_type AS ENUM (
  'doctor',              -- Medical doctor
  'nurse',               -- Nursing staff
  'technician',          -- Medical technician
  'administrative',      -- Administrative staff
  'manager',             -- Management staff
  'reception',           -- Reception/front desk
  'pharmacist',          -- Pharmacy staff
  'intern',              -- Intern/trainee
  'contractor'           -- External contractor
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory and Supply Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Inventory category enumeration
-- Categorizes medical supplies and equipment
CREATE TYPE inventory_category AS ENUM (
  'medication',          -- Pharmaceutical products
  'medical_supplies',    -- Consumables (bandages, syringes, etc.)
  'equipment',           -- Reusable medical equipment
  'diagnostic_tools',    -- Diagnostic devices
  'surgical_instruments',-- Surgery instruments
  'office_supplies',     -- Office materials
  'cleaning_supplies',   -- Disinfectants and cleaning materials
  'other'                -- Miscellaneous items
);

-- ══════════════════════════════════════════════════════════════════════════════
-- System and Audit Enums
-- ══════════════════════════════════════════════════════════════════════════════

-- Audit action type enumeration
-- Records types of system actions for audit logging
CREATE TYPE audit_action_type AS ENUM (
  'create',              -- Record created
  'read',                -- Record accessed/read
  'update',              -- Record modified
  'delete',              -- Record deleted
  'restore',             -- Deleted record restored
  'archive',             -- Record archived
  'login',               -- User login
  'logout',              -- User logout
  'export',              -- Data exported
  'import',              -- Data imported
  'permission_change',   -- Permission/role changed
  'config_change'        -- Configuration changed
);

-- Session status enumeration
-- Tracks user session states
CREATE TYPE session_status AS ENUM (
  'active',              -- User currently logged in
  'idle',                -- User inactive for period
  'suspended',           -- Session temporarily suspended
  'expired',             -- Session time expired
  'revoked'              -- Session forcibly ended
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Comment
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TYPE user_role IS 'User roles and permissions in the MCS system';
COMMENT ON TYPE appointment_status IS 'Appointment lifecycle status values';
COMMENT ON TYPE invoice_status IS 'Invoice and payment status values';
COMMENT ON TYPE subscription_type IS 'Service subscription plan types';
COMMENT ON TYPE video_session_status IS 'Telemedicine session status values';
COMMENT ON TYPE notification_type IS 'Notification category types';
COMMENT ON TYPE blood_pressure_status IS 'Blood pressure classification levels';
COMMENT ON TYPE temperature_status IS 'Body temperature classification levels';
COMMENT ON TYPE lab_result_type IS 'Medical test result types';
COMMENT ON TYPE assessment_type IS 'Clinical assessment types';
COMMENT ON TYPE bug_report_status IS 'Bug report lifecycle status';
COMMENT ON TYPE employee_type IS 'Clinic employee position types';
COMMENT ON TYPE inventory_category IS 'Medical supply and equipment categories';
COMMENT ON TYPE audit_action_type IS 'System audit log action types';
COMMENT ON TYPE session_status IS 'User session status values';
