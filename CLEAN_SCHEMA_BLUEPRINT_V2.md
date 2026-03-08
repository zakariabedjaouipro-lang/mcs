# MCS - Clean Schema Blueprint v2
## Controlled Database Rebuild Strategy

**Date:** March 4, 2026  
**Version:** 2.0  
**Status:** AWAITING APPROVAL  
**Strategy:** Complete Schema Rebuild (Zero-Cost Reset)

---

## Executive Summary

This blueprint outlines a **complete database schema rebuild** for the Medical Clinic Management System (MCS). Given that there is NO production data and NO active users, we will execute a **controlled reset** rather than incremental patching.

**Objectives:**
1. ✅ Create deterministic migration order
2. ✅ Standardize all IDs to UUID
3. ✅ Remove duplicate tables entirely
4. ✅ Rebuild foreign key graph cleanly
5. ✅ Re-implement RLS from foundation level
6. ✅ Generate fresh migration baseline

**Estimated Effort:** 60-80 hours  
**Risk Level:** LOW (No production data to lose)  
**Success Probability:** 95%

---

## 1️⃣ Complete Table Inventory

### Core Tables (Foundation)

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 1 | `users` | Extended user profiles | UUID | ✅ Keep |
| 2 | `countries` | Country reference data | UUID | ➕ Create |
| 3 | `regions` | Regional reference data | UUID | ➕ Create |
| 4 | `clinics` | Medical clinic information | UUID | ✅ Keep |

### Medical Entity Tables

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 5 | `specialties` | Medical specialties | UUID | ⚠️ Fix (currently TEXT) |
| 6 | `doctors` | Doctor profiles | UUID | 🔄 Merge duplicates |
| 7 | `patients` | Patient profiles | UUID | ✅ Keep |
| 8 | `employees` | Employee profiles | UUID | ✅ Keep |

### Junction Tables

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 9 | `clinic_staff` | Clinic-staff relationships | UUID | ✅ Keep |

### Clinical Workflow Tables

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 10 | `appointments` | Medical appointments | UUID | ✅ Keep |
| 11 | `prescriptions` | Medical prescriptions | UUID | ✅ Keep |
| 12 | `prescription_items` | Prescription medications | UUID | ✅ Keep |
| 13 | `lab_results` | Laboratory test results | UUID | ✅ Keep |
| 14 | `vital_signs` | Patient vital signs | UUID | ✅ Keep |
| 15 | `video_sessions` | Telemedicine sessions | UUID | ✅ Keep |

### Administrative Tables

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 16 | `invoices` | Billing invoices | UUID | ✅ Keep |
| 17 | `invoice_items` | Invoice line items | UUID | ✅ Keep |
| 18 | `inventory` | Medical inventory | UUID | ✅ Keep |
| 19 | `inventory_transactions` | Stock movements | UUID | ✅ Keep |
| 20 | `notifications` | User notifications | UUID | ✅ Keep |
| 21 | `notification_settings` | Notification preferences | UUID | ✅ Keep |
| 22 | `reports` | Generated reports | UUID | ✅ Keep |

### Subscription & Billing Tables

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 23 | `subscriptions` | Clinic subscriptions | UUID | ➕ Create |
| 24 | `subscription_codes` | Subscription activation codes | UUID | ⚠️ Fix (currently TEXT) |
| 25 | `exchange_rates` | Currency exchange rates | UUID | ⚠️ Fix (currently TEXT) |

### Assessment & Support Tables

| # | Table Name | Purpose | Primary Key | Status |
|---|------------|---------|-------------|--------|
| 26 | `autism_assessments` | Autism disorder assessments | UUID | ✅ Keep |
| 27 | `bug_reports` | System bug reports | UUID | ✅ Keep |

**Total Tables:** 27 tables  
**Tables to Create:** 3 (countries, regions, subscriptions)  
**Tables to Fix:** 4 (specialties, subscription_codes, exchange_rates, doctors)  
**Tables to Keep:** 20 (already UUID-based)

---

## 2️⃣ Deterministic Migration Order

### Migration Dependency Graph

```
┌─────────────────────────────────────────────────────────────────┐
│                     MIGRATION DEPENDENCY GRAPH                  │
└─────────────────────────────────────────────────────────────────┘

LAYER 1: Foundation (No Dependencies)
├─ 001_create_enums.sql
├─ 002_create_countries_table.sql [NEW]
├─ 003_create_regions_table.sql [NEW]
└─ 004_create_users_table.sql

LAYER 2: Core Entities (Depend on Layer 1)
├─ 005_create_specialties_table.sql [FIXED - UUID]
├─ 006_create_clinics_table.sql
└─ 007_create_subscriptions_table.sql [NEW]

LAYER 3: Medical Entities (Depend on Layer 2)
├─ 008_create_doctors_table.sql [MERGED - Single table]
├─ 009_create_patients_table.sql
├─ 010_create_employees_table.sql
└─ 011_create_clinic_staff_table.sql

LAYER 4: Clinical Workflow (Depend on Layer 3)
├─ 012_create_appointments_table.sql
├─ 013_create_prescriptions_table.sql
├─ 014_create_prescription_items_table.sql
├─ 015_create_lab_results_table.sql
├─ 016_create_vital_signs_table.sql
└─ 017_create_video_sessions_table.sql

LAYER 5: Administrative (Depend on Layer 3 & 4)
├─ 018_create_invoices_table.sql
├─ 019_create_invoice_items_table.sql
├─ 020_create_inventory_table.sql
├─ 021_create_inventory_transactions_table.sql
└─ 022_create_reports_table.sql

LAYER 6: Subscription & Billing (Depend on Layer 2 & 3)
├─ 023_create_subscription_codes_table.sql [FIXED - UUID]
└─ 024_create_exchange_rates_table.sql [FIXED - UUID]

LAYER 7: Notifications & Support (Depend on Layer 3)
├─ 025_create_notifications_table.sql
├─ 026_create_notification_settings_table.sql
└─ 027_create_autism_assessments_table.sql

LAYER 8: System Support (No Dependencies)
└─ 028_create_bug_reports_table.sql
```

### Migration Execution Order

```
Phase 1: Foundation (4 migrations)
  001_create_enums.sql
  002_create_countries_table.sql
  003_create_regions_table.sql
  004_create_users_table.sql

Phase 2: Core (3 migrations)
  005_create_specialties_table.sql
  006_create_clinics_table.sql
  007_create_subscriptions_table.sql

Phase 3: Medical (4 migrations)
  008_create_doctors_table.sql
  009_create_patients_table.sql
  010_create_employees_table.sql
  011_create_clinic_staff_table.sql

Phase 4: Clinical (6 migrations)
  012_create_appointments_table.sql
  013_create_prescriptions_table.sql
  014_create_prescription_items_table.sql
  015_create_lab_results_table.sql
  016_create_vital_signs_table.sql
  017_create_video_sessions_table.sql

Phase 5: Administrative (5 migrations)
  018_create_invoices_table.sql
  019_create_invoice_items_table.sql
  020_create_inventory_table.sql
  021_create_inventory_transactions_table.sql
  022_create_reports_table.sql

Phase 6: Subscription (2 migrations)
  023_create_subscription_codes_table.sql
  024_create_exchange_rates_table.sql

Phase 7: Notifications (3 migrations)
  025_create_notifications_table.sql
  026_create_notification_settings_table.sql
  027_create_autism_assessments_table.sql

Phase 8: Support (1 migration)
  028_create_bug_reports_table.sql

Total: 28 migrations
```

---

## 3️⃣ UUID Standardization

### Standardization Rules

**Rule 1: All Primary Keys = UUID**
- Every table must use `UUID PRIMARY KEY DEFAULT gen_random_uuid()`
- No exceptions, no TEXT IDs, no INT IDs

**Rule 2: All Foreign Keys = UUID**
- All foreign key references must be UUID type
- No mixed type references

**Rule 3: Consistent Naming**
- Primary key column: `id`
- Foreign key column: `{table}_id` (e.g., `user_id`, `clinic_id`)

### Tables Requiring UUID Conversion

| Table | Current Type | Target Type | Conversion Strategy |
|-------|--------------|-------------|---------------------|
| `specialties` | TEXT | UUID | Recreate table with UUID PK |
| `subscription_codes` | TEXT | UUID | Recreate table with UUID PK |
| `exchange_rates` | TEXT | UUID | Recreate table with UUID PK |
| `doctors` (duplicate) | UUID | UUID | Remove duplicate 017, keep 004 |

### UUID Standardization Implementation

```sql
-- Standard UUID primary key pattern
CREATE TABLE example_table (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- other columns
);

-- Standard UUID foreign key pattern
CREATE TABLE referencing_table (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    example_id UUID REFERENCES example_table(id) ON DELETE CASCADE,
    -- other columns
);
```

---

## 4️⃣ Clean Foreign Key Graph

### Foreign Key Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                     FOREIGN KEY RELATIONSHIPS                   │
└─────────────────────────────────────────────────────────────────┘

users (Foundation)
  ├─► clinics (created_by, updated_by)
  ├─► doctors (user_id)
  ├─► patients (user_id)
  ├─► employees (user_id)
  ├─► clinic_staff (user_id)
  ├─► appointments (created_by, updated_by)
  ├─► prescriptions (created_by, updated_by)
  ├─► invoices (created_by, updated_by)
  ├─► inventory (created_by, updated_by)
  ├─► lab_results (created_by, updated_by)
  ├─► video_sessions (initiator_id)
  ├─► reports (generated_by)
  ├─► autism_assessments (created_by, updated_by)
  └─► bug_reports (user_id, assigned_to)

countries (Foundation)
  └─► regions (country_id)
      └─► clinics (region_id)

regions (Foundation)
  └─► clinics (region_id)

specialties (Core)
  └─► doctors (specialty_id)

clinics (Core)
  ├─► doctors (clinic_id)
  ├─► patients (preferred_clinic_id)
  ├─► employees (clinic_id)
  ├─► clinic_staff (clinic_id)
  ├─► appointments (clinic_id)
  ├─► prescriptions (clinic_id)
  ├─► lab_results (clinic_id)
  ├─► vital_signs (clinic_id)
  ├─► video_sessions (clinic_id)
  ├─► invoices (clinic_id)
  ├─► inventory (clinic_id)
  ├─► reports (clinic_id)
  └─► autism_assessments (clinic_id)

subscriptions (Core)
  └─► clinics (subscription_id)

doctors (Medical)
  ├─► patients (preferred_doctor_id)
  ├─► appointments (doctor_id)
  ├─► prescriptions (doctor_id)
  ├─► lab_results (doctor_id)
  ├─► vital_signs (doctor_id)
  └─► video_sessions (doctor_id)

patients (Medical)
  ├─► appointments (patient_id)
  ├─► prescriptions (patient_id)
  ├─► lab_results (patient_id)
  ├─► vital_signs (patient_id)
  ├─► video_sessions (patient_id)
  └─► invoices (patient_id)

employees (Medical)
  └─► clinic_staff (employee_id)

clinic_staff (Junction)
  └─► employees (manager_id)

appointments (Clinical)
  ├─► prescriptions (appointment_id)
  ├─► lab_results (appointment_id)
  ├─► vital_signs (appointment_id)
  ├─► video_sessions (appointment_id)
  └─► invoices (appointment_id)

prescriptions (Clinical)
  └─► prescription_items (prescription_id)

invoices (Administrative)
  └─► invoice_items (invoice_id)

inventory (Administrative)
  └─► inventory_transactions (inventory_id)
```

### Foreign Key Constraints

**Cascade Rules:**
- `ON DELETE CASCADE`: Delete dependent records when parent is deleted
  - Used for: doctor-patient, appointment-prescription, etc.
- `ON DELETE SET NULL`: Set FK to NULL when parent is deleted
  - Used for: optional relationships (clinic_id, doctor_id in some tables)
- `ON DELETE RESTRICT`: Prevent deletion if dependent records exist
  - Used for: critical relationships (users, clinics)

**Constraint Naming Convention:**
```
fk_{table}_{column}_references_{referenced_table}
```

---

## 5️⃣ RLS Policies from Foundation Level

### RLS Policy Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     RLS POLICY ARCHITECTURE                     │
└─────────────────────────────────────────────────────────────────┘

PRINCIPLE 1: Role-Based Access Control
  └─ Policies based on user_role enum

PRINCIPLE 2: Row-Level Isolation
  └─ Users can only access their own data
  └─ Clinic staff can access clinic data
  └─ Super admins can access all data

PRINCIPLE 3: Least Privilege
  └─ Grant minimum necessary permissions
  └─ Separate READ, INSERT, UPDATE, DELETE policies

PRINCIPLE 4: Audit Trail
  └─ All data modifications tracked
  └─ created_by/updated_by fields populated
```

### Standard RLS Policy Templates

#### Template 1: User-Owned Data
```sql
-- Users can read their own data
CREATE POLICY "users_read_own_data"
  ON {table} FOR SELECT
  USING (user_id = auth.uid() OR id = auth.uid());

-- Users can update their own data
CREATE POLICY "users_update_own_data"
  ON {table} FOR UPDATE
  USING (user_id = auth.uid() OR id = auth.uid());
```

#### Template 2: Clinic Data Access
```sql
-- Clinic staff can read clinic data
CREATE POLICY "clinic_staff_read_clinic_data"
  ON {table} FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Clinic staff can update clinic data
CREATE POLICY "clinic_staff_update_clinic_data"
  ON {table} FOR UPDATE
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('admin', 'manager')
    )
  );
```

#### Template 3: Super Admin Access
```sql
-- Super admins can read all data
CREATE POLICY "super_admin_read_all"
  ON {table} FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );
```

### RLS Policy Matrix

| Table | Read Policy | Insert Policy | Update Policy | Delete Policy |
|-------|-------------|---------------|---------------|---------------|
| `users` | Own + Super Admin | Self | Own (non-sensitive) | Super Admin |
| `clinics` | Public + Own | Authenticated | Own | Own |
| `doctors` | Public + Own | Clinic Admin | Own + Clinic Admin | None |
| `patients` | Own + Doctor | Self | Own + Doctor | None |
| `appointments` | Own + Doctor + Clinic | Patient | Doctor + Clinic | None |
| `prescriptions` | Own + Doctor + Clinic | Doctor | Doctor + Clinic | None |
| `invoices` | Own + Clinic | Clinic Staff | Clinic Staff | None |
| `inventory` | Clinic Staff | Clinic Staff | Clinic Staff | None |
| `notifications` | Own | System | Own | None |

---

## 6️⃣ Migration Baseline

### New Migration Files

#### 001_create_enums.sql (KEEP - No Changes)
- All enums already defined correctly
- No changes needed

#### 002_create_countries_table.sql (NEW)
```sql
-- Create countries table
CREATE TABLE IF NOT EXISTS countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    name_ar VARCHAR(100),
    iso2_code VARCHAR(2) UNIQUE NOT NULL,
    iso3_code VARCHAR(3) UNIQUE NOT NULL,
    phone_code VARCHAR(10) NOT NULL,
    currency_code VARCHAR(3) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_countries_iso2_code ON countries(iso2_code);
CREATE INDEX idx_countries_iso3_code ON countries(iso3_code);
CREATE INDEX idx_countries_is_active ON countries(is_active);

-- Insert default countries
INSERT INTO countries (name, name_ar, iso2_code, iso3_code, phone_code, currency_code) VALUES
    ('United States', 'الولايات المتحدة', 'US', 'USA', '+1', 'USD'),
    ('Algeria', 'الجزائر', 'DZ', 'DZA', '+213', 'DZD'),
    ('France', 'فرنسا', 'FR', 'FRA', '+33', 'EUR'),
    ('United Kingdom', 'المملكة المتحدة', 'GB', 'GBR', '+44', 'GBP'),
    ('Germany', 'ألمانيا', 'DE', 'DEU', '+49', 'EUR');

-- RLS
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "everyone_can_read_countries" ON countries FOR SELECT USING (true);
```

#### 003_create_regions_table.sql (NEW)
```sql
-- Create regions table
CREATE TABLE IF NOT EXISTS regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    country_id UUID REFERENCES countries(id) ON DELETE CASCADE NOT NULL,
    name VARCHAR(100) NOT NULL,
    name_ar VARCHAR(100),
    code VARCHAR(10) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_regions_country_id ON regions(country_id);
CREATE INDEX idx_regions_code ON regions(code);
CREATE INDEX idx_regions_is_active ON regions(is_active);

-- Insert default regions for Algeria
INSERT INTO regions (country_id, name, name_ar, code) VALUES
    ((SELECT id FROM countries WHERE iso2_code = 'DZ'), 'Algiers', 'الجزائر العاصمة', '01'),
    ((SELECT id FROM countries WHERE iso2_code = 'DZ'), 'Oran', 'وهران', '31'),
    ((SELECT id FROM countries WHERE iso2_code = 'DZ'), 'Constantine', 'قسنطينة', '25');

-- RLS
ALTER TABLE regions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "everyone_can_read_regions" ON regions FOR SELECT USING (true);
```

#### 005_create_specialties_table.sql (FIXED - UUID)
```sql
-- Create specialties table with UUID primary key
CREATE TABLE IF NOT EXISTS specialties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_en VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255) NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    icon_name VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE UNIQUE INDEX idx_specialties_name_en ON specialties(name_en);
CREATE INDEX idx_specialties_name_ar ON specialties(name_ar);
CREATE INDEX idx_specialties_icon_name ON specialties(icon_name);
CREATE INDEX idx_specialties_is_active ON specialties(is_active);

-- Insert default specialties
INSERT INTO specialties (name_en, name_ar, description_en, icon_name) VALUES
    ('Cardiology', 'أمراض القلب', 'Medical specialty focusing on heart diseases', 'cardiology'),
    ('Dermatology', 'الأمراض الجلدية', 'Medical specialty dealing with skin conditions', 'dermatology'),
    ('Neurology', 'الأعصاب', 'Medical specialty dealing with nervous system disorders', 'neurology'),
    ('Oncology', 'الأورام', 'Medical specialty dealing with cancer treatment', 'oncology'),
    ('Pediatrics', 'طب الأطفال', 'Medical specialty for infants, children, and adolescents', 'pediatrics'),
    ('Psychiatry', 'الطب النفسي', 'Medical specialty for mental health', 'psychiatry'),
    ('Orthopedics', 'العظام', 'Medical specialty for musculoskeletal system', 'orthopedics'),
    ('Ophthalmology', 'طب العيون', 'Medical specialty for eye diseases', 'ophthalmology'),
    ('General Practice', 'الطب العام', 'Medical specialty for common health issues', 'medical_services'),
    ('Emergency Medicine', 'طب الطوارئ', 'Medical specialty for emergency care', 'emergency_medicine');

-- RLS
ALTER TABLE specialties ENABLE ROW LEVEL SECURITY;
CREATE POLICY "everyone_can_read_specialties" ON specialties FOR SELECT USING (is_active = true);
```

#### 007_create_subscriptions_table.sql (NEW)
```sql
-- Create subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL CHECK (type IN ('trial', 'monthly', 'quarterly', 'half_yearly', 'yearly')),
    price_usd DECIMAL(10, 2) NOT NULL DEFAULT 0,
    price_eur DECIMAL(10, 2) NOT NULL DEFAULT 0,
    price_dzd DECIMAL(10, 2) NOT NULL DEFAULT 0,
    duration_days INTEGER NOT NULL,
    max_users INTEGER NOT NULL DEFAULT 10,
    max_doctors INTEGER NOT NULL DEFAULT 5,
    features JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_subscriptions_type ON subscriptions(type);
CREATE INDEX idx_subscriptions_is_active ON subscriptions(is_active);

-- Insert default subscription types
INSERT INTO subscriptions (type, price_usd, price_eur, price_dzd, duration_days, max_users, max_doctors) VALUES
    ('trial', 0, 0, 0, 30, 5, 2),
    ('monthly', 29.99, 27.99, 4000, 30, 25, 10),
    ('quarterly', 79.99, 74.99, 11000, 90, 50, 20),
    ('half_yearly', 149.99, 139.99, 20000, 180, 75, 30),
    ('yearly', 279.99, 259.99, 37000, 365, 100, 50);

-- RLS
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "everyone_can_read_subscriptions" ON subscriptions FOR SELECT USING (is_active = true);
CREATE POLICY "super_admin_manage_subscriptions" ON subscriptions FOR ALL USING (
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin')
);
```

#### 008_create_doctors_table.sql (MERGED - Keep only 004, remove 017)
```sql
-- Create doctors table (single, unified version)
CREATE TABLE IF NOT EXISTS doctors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    specialty_id UUID REFERENCES specialties(id) ON DELETE SET NULL,
    license_number VARCHAR(100) UNIQUE NOT NULL,
    license_expiry_date DATE,
    qualification VARCHAR(255),
    university VARCHAR(255),
    graduation_year INTEGER,
    experience_years INTEGER DEFAULT 0,
    bio TEXT,
    bio_ar TEXT,
    consultation_fee DECIMAL(10, 2) DEFAULT 0.00,
    consultation_fee_currency VARCHAR(3) DEFAULT 'USD',
    languages TEXT[] DEFAULT ARRAY[]::TEXT[],
    is_available BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INTEGER DEFAULT 0,
    profile_image_url TEXT,
    working_hours JSONB,
    max_patients_per_day INTEGER DEFAULT 20,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Indexes
CREATE INDEX idx_doctors_user_id ON doctors(user_id);
CREATE INDEX idx_doctors_clinic_id ON doctors(clinic_id);
CREATE INDEX idx_doctors_specialty_id ON doctors(specialty_id);
CREATE INDEX idx_doctors_is_available ON doctors(is_available);
CREATE INDEX idx_doctors_is_verified ON doctors(is_verified);
CREATE INDEX idx_doctors_rating ON doctors(rating DESC);

-- RLS
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_verified_doctors" ON doctors FOR SELECT USING (is_verified = true);
CREATE POLICY "doctors_read_own_profile" ON doctors FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "clinic_staff_read_clinic_doctors" ON doctors FOR SELECT USING (
  clinic_id IN (SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid())
);
CREATE POLICY "doctors_update_own_profile" ON doctors FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY "clinic_admin_update_clinic_doctors" ON doctors FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM clinic_staff
    WHERE clinic_id = doctors.clinic_id
    AND user_id = auth.uid()
    AND role IN ('admin', 'manager')
  )
);
```

#### 023_create_subscription_codes_table.sql (FIXED - UUID)
```sql
-- Create subscription_codes table with UUID primary key
CREATE TABLE IF NOT EXISTS subscription_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('trial', 'monthly', 'quarterly', 'half_yearly', 'yearly')),
    price_usd DECIMAL(10, 2) NOT NULL DEFAULT 0,
    price_eur DECIMAL(10, 2) NOT NULL DEFAULT 0,
    price_dzd DECIMAL(10, 2) NOT NULL DEFAULT 0,
    is_used BOOLEAN NOT NULL DEFAULT false,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_subscription_codes_code ON subscription_codes(code);
CREATE INDEX idx_subscription_codes_clinic_id ON subscription_codes(clinic_id);
CREATE INDEX idx_subscription_codes_is_used ON subscription_codes(is_used);
CREATE INDEX idx_subscription_codes_expires_at ON subscription_codes(expires_at);

-- RLS
ALTER TABLE subscription_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "super_admin_manage_subscription_codes" ON subscription_codes FOR ALL USING (
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin')
);
```

#### 024_create_exchange_rates_table.sql (FIXED - UUID)
```sql
-- Create exchange_rates table with UUID primary key
CREATE TABLE IF NOT EXISTS exchange_rates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_currency VARCHAR(3) NOT NULL,
    to_currency VARCHAR(3) NOT NULL,
    rate DECIMAL(10, 6) NOT NULL DEFAULT 1.0,
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(from_currency, to_currency, effective_date)
);

-- Indexes
CREATE INDEX idx_exchange_rates_from_currency ON exchange_rates(from_currency);
CREATE INDEX idx_exchange_rates_to_currency ON exchange_rates(to_currency);
CREATE INDEX idx_exchange_rates_effective_date ON exchange_rates(effective_date DESC);
CREATE INDEX idx_exchange_rates_is_active ON exchange_rates(is_active);

-- Insert default exchange rates
INSERT INTO exchange_rates (from_currency, to_currency, rate) VALUES
    ('USD', 'USD', 1.0),
    ('USD', 'EUR', 0.92),
    ('USD', 'DZD', 134.5),
    ('EUR', 'USD', 1.09),
    ('EUR', 'EUR', 1.0),
    ('EUR', 'DZD', 146.2),
    ('DZD', 'USD', 0.0074),
    ('DZD', 'EUR', 0.0068),
    ('DZD', 'DZD', 1.0);

-- RLS
ALTER TABLE exchange_rates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "everyone_read_active_exchange_rates" ON exchange_rates FOR SELECT USING (is_active = true);
CREATE POLICY "super_admin_manage_exchange_rates" ON exchange_rates FOR ALL USING (
  EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'super_admin')
);
```

### Migration Files to Delete

```
DELETE:
  └─ 017_create_doctors_table.sql (duplicate)
```

### Migration Files to Keep (No Changes)

```
KEEP:
  ├─ 001_create_enums.sql
  ├─ 004_create_users_table.sql
  ├─ 006_create_clinics_table.sql
  ├─ 009_create_patients_table.sql
  ├─ 010_create_employees_table.sql
  ├─ 011_create_clinic_staff_table.sql (merged from 007)
  ├─ 012_create_appointments_table.sql
  ├─ 013_create_prescriptions_table.sql
  ├─ 014_create_prescription_items_table.sql
  ├─ 015_create_lab_results_table.sql
  ├─ 016_create_vital_signs_table.sql
  ├─ 017_create_video_sessions_table.sql
  ├─ 018_create_invoices_table.sql
  ├─ 019_create_invoice_items_table.sql
  ├─ 020_create_inventory_table.sql
  ├─ 021_create_inventory_transactions_table.sql
  ├─ 022_create_reports_table.sql
  ├─ 025_create_notifications_table.sql
  ├─ 026_create_notification_settings_table.sql
  ├─ 027_create_autism_assessments_table.sql
  └─ 028_create_bug_reports_table.sql
```

---

## 7️⃣ Execution Plan

### Phase 1: Preparation (8 hours)

**Tasks:**
1. ✅ Create backup of existing migrations
2. ✅ Document current schema state
3. ✅ Prepare new migration files
4. ✅ Review and validate blueprint

**Deliverables:**
- Migration backup archive
- Schema state documentation
- New migration files ready

### Phase 2: Database Reset (4 hours)

**Tasks:**
1. ✅ Drop existing database (if exists)
2. ✅ Create fresh database
3. ✅ Execute migrations in order
4. ✅ Verify schema creation

**Commands:**
```sql
-- Drop existing database
DROP DATABASE IF EXISTS mcs_dev;

-- Create fresh database
CREATE DATABASE mcs_dev;

-- Connect to database
\c mcs_dev

-- Execute migrations
-- (Execute 001-028 in order)
```

**Deliverables:**
- Clean database created
- All migrations executed successfully
- Schema verification complete

### Phase 3: Model Updates (16 hours)

**Tasks:**
1. ✅ Update DoctorModel (specialtyId: int → UUID)
2. ✅ Update SubscriptionModel (id: TEXT → UUID)
3. ✅ Update ExchangeRateModel (id: TEXT → UUID)
4. ✅ Add CountryModel and RegionModel
5. ✅ Update all fromJson/toJson methods
6. ✅ Update all services using models

**Files to Update:**
- `lib/core/models/doctor_model.dart`
- `lib/core/models/subscription_model.dart`
- `lib/core/models/exchange_rate_model.dart`
- `lib/core/models/country_model.dart` (NEW)
- `lib/core/models/region_model.dart` (NEW)
- `lib/core/services/supabase_service.dart`
- `lib/features/admin/presentation/bloc/admin_bloc.dart`

**Deliverables:**
- All models updated
- All services updated
- Type safety verified

### Phase 4: RLS Policy Testing (12 hours)

**Tasks:**
1. ✅ Create test users for each role
2. ✅ Test RLS policies for each table
3. ✅ Verify data isolation
4. ✅ Test cross-role access
5. ✅ Document any policy issues

**Test Cases:**
- Patient can only see own data
- Doctor can see clinic patients
- Clinic admin can manage clinic data
- Super admin can access all data
- Cross-clinic access blocked

**Deliverables:**
- RLS policy test results
- Security verification report
- Policy documentation

### Phase 5: Integration Testing (20 hours)

**Tasks:**
1. ✅ Test appointment booking flow
2. ✅ Test prescription creation flow
3. ✅ Test invoice generation flow
4. ✅ Test inventory management flow
5. ✅ Test video session flow
6. ✅ Test subscription activation flow
7. ✅ Test currency conversion flow

**Deliverables:**
- Integration test results
- Bug report (if any)
- Performance metrics

### Phase 6: Documentation (10 hours)

**Tasks:**
1. ✅ Update schema documentation
2. ✅ Create migration guide
3. ✅ Create RLS policy guide
4. ✅ Update API documentation
5. ✅ Create troubleshooting guide

**Deliverables:**
- Complete schema documentation
- Migration guide
- RLS policy guide
- API documentation updates
- Troubleshooting guide

### Phase 7: Validation & Sign-off (10 hours)

**Tasks:**
1. ✅ Final schema validation
2. ✅ Performance testing
3. ✅ Security audit
4. ✅ Stakeholder review
5. ✅ Production readiness assessment

**Deliverables:**
- Validation report
- Performance report
- Security audit report
- Stakeholder approval
- Production readiness assessment

### Total Timeline

| Phase | Duration | Dependencies |
|-------|----------|--------------|
| Phase 1: Preparation | 8 hours | None |
| Phase 2: Database Reset | 4 hours | Phase 1 |
| Phase 3: Model Updates | 16 hours | Phase 2 |
| Phase 4: RLS Testing | 12 hours | Phase 3 |
| Phase 5: Integration Testing | 20 hours | Phase 4 |
| Phase 6: Documentation | 10 hours | Phase 5 |
| Phase 7: Validation | 10 hours | Phase 6 |

**Total:** 80 hours (2 weeks with 1 developer)

---

## 8️⃣ Risk Assessment

### Low Risk Factors

✅ **No Production Data** - Zero data loss risk  
✅ **No Active Users** - Zero user impact  
✅ **Fresh Start** - No technical debt to preserve  
✅ **Controlled Environment** - Development environment only  
✅ **Rollback Available** - Can restore from backup if needed

### Medium Risk Factors

⚠️ **Migration Complexity** - 28 migrations to execute  
⚠️ **Model Updates** - Multiple files to update  
⚠️ **RLS Policy Complexity** - Complex permission logic  
⚠️ **Testing Effort** - Comprehensive testing required

### Mitigation Strategies

1. **Backup Before Reset**
   - Export existing database schema
   - Archive all migration files
   - Document current state

2. **Incremental Testing**
   - Test each migration individually
   - Verify schema after each phase
   - Rollback on failure

3. **Automated Validation**
   - Create validation scripts
   - Automated schema checks
   - Continuous integration testing

4. **Code Review**
   - Peer review all changes
   - Security review of RLS policies
   - Performance review of queries

### Risk Matrix

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Migration failure | Low | High | Backup, incremental testing |
| Model bugs | Medium | Medium | Unit tests, code review |
| RLS policy漏洞 | Low | Critical | Security audit, penetration testing |
| Performance issues | Medium | Medium | Load testing, query optimization |
| Data corruption | Very Low | Critical | Transaction rollback, validation |

**Overall Risk Level:** LOW  
**Risk Mitigation:** COMPREHENSIVE  
**Confidence Level:** HIGH

---

## 9️⃣ Success Criteria

### Technical Criteria

✅ **All 28 migrations execute successfully**  
✅ **All tables use UUID primary keys**  
✅ **All foreign keys are UUID type**  
✅ **No duplicate tables exist**  
✅ **All RLS policies functional**  
✅ **All models match database schema**  
✅ **All services updated**  
✅ **Zero compilation errors**  
✅ **Zero runtime errors**  
✅ **Integration tests pass**

### Functional Criteria

✅ **User authentication works**  
✅ **Appointment booking works**  
✅ **Prescription creation works**  
✅ **Invoice generation works**  
✅ **Inventory management works**  
✅ **Video sessions work**  
✅ **Subscription activation works**  
✅ **Currency conversion works**

### Security Criteria

✅ **Patients can only access own data**  
✅ **Doctors can access clinic patients**  
✅ **Clinic admins can manage clinic data**  
✅ **Super admins can access all data**  
✅ **Cross-clinic access blocked**  
✅ **Audit trail functional**  
✅ **No security vulnerabilities**

### Performance Criteria

✅ **Query response time < 100ms**  
✅ **Migration execution time < 5 minutes**  
✅ **No N+1 query problems**  
✅ **Proper indexing**  
✅ **No deadlocks**

---

## 🔟 Approval Checklist

### Pre-Approval Checklist

- [ ] Blueprint reviewed by technical lead
- [ ] Blueprint reviewed by database administrator
- [ ] Blueprint reviewed by security team
- [ ] Blueprint reviewed by project manager
- [ ] Stakeholders informed of rebuild plan
- [ ] Backup strategy confirmed
- [ ] Rollback plan documented
- [ ] Timeline approved
- [ ] Resources allocated
- [ ] Risk mitigation accepted

### Post-Approval Checklist

- [ ] Migration files created
- [ ] Model updates completed
- [ ] RLS policies tested
- [ ] Integration tests passed
- [ ] Documentation completed
- [ ] Validation successful
- [ ] Stakeholder sign-off received
- [ ] Production readiness confirmed

---

## 📋 Summary

### What Will Be Done

1. **Create 3 new tables:** countries, regions, subscriptions
2. **Fix 4 tables:** specialties, subscription_codes, exchange_rates, doctors
3. **Delete 1 duplicate table:** doctors (migration 017)
4. **Standardize 27 tables** to use UUID primary keys
5. **Create 28 deterministic migrations**
6. **Implement comprehensive RLS policies**
7. **Update all models and services**
8. **Test all functionality end-to-end**

### What Will NOT Be Done

❌ No incremental patching  
❌ No data migration (no data exists)  
❌ No backward compatibility (fresh start)  
❌ No feature development (architecture first)

### Expected Outcome

✅ Clean, deterministic database schema  
✅ All UUID primary keys  
✅ No duplicate tables  
✅ Clean foreign key relationships  
✅ Comprehensive RLS policies  
✅ Type-safe models  
✅ Production-ready foundation  
✅ Zero technical debt

---

## 📞 Next Steps

1. **Review this blueprint** with technical team
2. **Approve or reject** the rebuild strategy
3. **Allocate resources** for execution
4. **Schedule execution** timeline
5. **Begin Phase 1** upon approval

---

**Blueprint Version:** 2.0  
**Status:** AWAITING APPROVAL  
**Approval Required:** YES  
**Estimated Start Date:** TBD  
**Estimated Completion Date:** TBD  
**Total Effort:** 80 hours (2 weeks)

---

**Prepared By:** Principal Software Architect  
**Date:** March 4, 2026  
**Next Review:** After approval