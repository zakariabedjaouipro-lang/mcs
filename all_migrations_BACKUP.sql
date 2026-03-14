-- Migration: Create Enums for MCS Database
-- Purpose: Define PostgreSQL enum types used throughout the application
-- Version: v2_P01_001
-- Created: 2026-03-04
-- Dependencies: None

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
-- Comments
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
-- Migration: Create Countries Table
-- Purpose: Store country reference data for user and clinic locations
-- Version: v2_P01_002
-- Created: 2026-03-04
-- Dependencies: None

-- ══════════════════════════════════════════════════════════════════════════════
-- Countries Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create countries table to store country reference data
CREATE TABLE IF NOT EXISTS countries (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Country Information
  name VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255),
  iso2_code VARCHAR(2) NOT NULL UNIQUE,  -- 2-letter ISO code (e.g., US, DZ)
  iso3_code VARCHAR(3) NOT NULL UNIQUE,  -- 3-letter ISO code (e.g., USA, DZA)
  numeric_code INTEGER UNIQUE,            -- Numeric ISO code (e.g., 840 for US)
  phone_code VARCHAR(10) NOT NULL,       -- Country calling code (e.g., +1, +213)
  currency_code VARCHAR(3),               -- Currency code (e.g., USD, DZD)
  currency_name VARCHAR(50),
  currency_name_ar VARCHAR(50),
  currency_symbol VARCHAR(10),

  -- Geographic Information
  continent VARCHAR(50),
  region VARCHAR(100),
  subregion VARCHAR(100),
  capital VARCHAR(100),
  capital_ar VARCHAR(100),

  -- Status and Metadata
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_supported BOOLEAN NOT NULL DEFAULT true,  -- Whether app supports this country

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_iso2_code CHECK (iso2_code ~ '^[A-Z]{2}$'),
  CONSTRAINT valid_iso3_code CHECK (iso3_code ~ '^[A-Z]{3}$'),
  CONSTRAINT valid_phone_code CHECK (phone_code ~ '^\+\d{1,4}$')
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_countries_iso2_code ON countries(iso2_code) WHERE is_active = true;
CREATE INDEX idx_countries_iso3_code ON countries(iso3_code) WHERE is_active = true;
CREATE INDEX idx_countries_name ON countries(name) WHERE is_active = true;
CREATE INDEX idx_countries_is_active ON countries(is_active);
CREATE INDEX idx_countries_is_supported ON countries(is_supported) WHERE is_supported = true;
CREATE INDEX idx_countries_continent ON countries(continent) WHERE is_active = true;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on countries table
ALTER TABLE countries ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active countries
CREATE POLICY "Active countries are viewable by everyone"
  ON countries FOR SELECT
  USING (is_active = true);

-- Policy: Everyone can view supported countries
CREATE POLICY "Supported countries are viewable by everyone"
  ON countries FOR SELECT
  USING (is_supported = true);

-- Policy: Super admins can manage countries
-- Note: This policy will be updated after users table is created
-- For now, allow service role to manage countries
CREATE POLICY "Service role can manage countries"
  ON countries FOR ALL
  USING (auth.role() = 'service_role');

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_countries_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER countries_update_updated_at
  BEFORE UPDATE ON countries
  FOR EACH ROW
  EXECUTE FUNCTION update_countries_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE countries IS 'Country reference data for user and clinic locations';
COMMENT ON COLUMN countries.id IS 'Primary key (UUID)';
COMMENT ON COLUMN countries.name IS 'Country name in English';
COMMENT ON COLUMN countries.name_ar IS 'Country name in Arabic';
COMMENT ON COLUMN countries.iso2_code IS '2-letter ISO country code (e.g., US, DZ)';
COMMENT ON COLUMN countries.iso3_code IS '3-letter ISO country code (e.g., USA, DZA)';
COMMENT ON COLUMN countries.numeric_code IS 'Numeric ISO country code';
COMMENT ON COLUMN countries.phone_code IS 'Country calling code (e.g., +1, +213)';
COMMENT ON COLUMN countries.currency_code IS 'Currency code (e.g., USD, DZD)';
COMMENT ON COLUMN countries.currency_name IS 'Currency name in English';
COMMENT ON COLUMN countries.currency_name_ar IS 'Currency name in Arabic';
COMMENT ON COLUMN countries.currency_symbol IS 'Currency symbol (e.g., $, دج)';
COMMENT ON COLUMN countries.continent IS 'Continent name';
COMMENT ON COLUMN countries.region IS 'Region name';
COMMENT ON COLUMN countries.subregion IS 'Subregion name';
COMMENT ON COLUMN countries.capital IS 'Capital city name';
COMMENT ON COLUMN countries.is_active IS 'Whether the country is active';
COMMENT ON COLUMN countries.is_supported IS 'Whether the app supports this country';

-- ══════════════════════════════════════════════════════════════════════════════
-- Seed Data
-- ══════════════════════════════════════════════════════════════════════════════

-- Insert common countries
INSERT INTO countries (name, name_ar, iso2_code, iso3_code, numeric_code, phone_code, currency_code, currency_name, currency_name_ar, currency_symbol, continent, region, subregion, capital, capital_ar) VALUES
-- Algeria (Primary market)
('Algeria', 'الجزائر', 'DZ', 'DZA', 12, '+213', 'DZD', 'Algerian Dinar', 'دينار جزائري', 'دج', 'Africa', 'Africa', 'Northern Africa', 'Algiers', 'الجزائر'),

-- Other Arab countries
('Morocco', 'المغرب', 'MA', 'MAR', 504, '+212', 'MAD', 'Moroccan Dirham', 'درهم مغربي', 'DH', 'Africa', 'Africa', 'Northern Africa', 'Rabat', 'الرباط'),
('Tunisia', 'تونس', 'TN', 'TUN', 788, '+216', 'TND', 'Tunisian Dinar', 'دينار تونسي', 'DT', 'Africa', 'Africa', 'Northern Africa', 'Tunis', 'تونس'),
('Egypt', 'مصر', 'EG', 'EGY', 818, '+20', 'EGP', 'Egyptian Pound', 'جنيه مصري', 'E£', 'Africa', 'Africa', 'Northern Africa', 'Cairo', 'القاهرة'),
('Saudi Arabia', 'المملكة العربية السعودية', 'SA', 'SAU', 682, '+966', 'SAR', 'Saudi Riyal', 'ريال سعودي', 'ر.س', 'Asia', 'Asia', 'Western Asia', 'Riyadh', 'الرياض'),
('United Arab Emirates', 'الإمارات العربية المتحدة', 'AE', 'ARE', 784, '+971', 'AED', 'UAE Dirham', 'درهم إماراتي', 'DH', 'Asia', 'Asia', 'Western Asia', 'Abu Dhabi', 'أبو ظبي'),
('Qatar', 'قطر', 'QA', 'QAT', 634, '+974', 'QAR', 'Qatari Riyal', 'ريال قطري', 'ر.ق', 'Asia', 'Asia', 'Western Asia', 'Doha', 'الدوحة'),
('Kuwait', 'الكويت', 'KW', 'KWT', 414, '+965', 'KWD', 'Kuwaiti Dinar', 'دينار كويتي', 'د.ك', 'Asia', 'Asia', 'Western Asia', 'Kuwait City', 'مدينة الكويت'),

-- Major countries
('United States', 'الولايات المتحدة', 'US', 'USA', 840, '+1', 'USD', 'US Dollar', 'دولار أمريكي', '$', 'North America', 'Americas', 'Northern America', 'Washington, D.C.', 'واشنطن العاصمة'),
('United Kingdom', 'المملكة المتحدة', 'GB', 'GBR', 826, '+44', 'GBP', 'British Pound', 'جنيه إسترليني', '£', 'Europe', 'Europe', 'Northern Europe', 'London', 'لندن'),
('France', 'فرنسا', 'FR', 'FRA', 250, '+33', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Western Europe', 'Paris', 'باريس'),
('Germany', 'ألمانيا', 'DE', 'DEU', 276, '+49', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Western Europe', 'Berlin', 'برلين'),
('Canada', 'كندا', 'CA', 'CAN', 124, '+1', 'CAD', 'Canadian Dollar', 'دولار كندي', '$', 'North America', 'Americas', 'Northern America', 'Ottawa', 'أوتاوا'),
('Australia', 'أستراليا', 'AU', 'AUS', 36, '+61', 'AUD', 'Australian Dollar', 'دولار أسترالي', '$', 'Oceania', 'Oceania', 'Australia and New Zealand', 'Canberra', 'كانبيرا'),
('Japan', 'اليابان', 'JP', 'JPN', 392, '+81', 'JPY', 'Japanese Yen', 'ين ياباني', '¥', 'Asia', 'Asia', 'Eastern Asia', 'Tokyo', 'طوكيو'),
('China', 'الصين', 'CN', 'CHN', 156, '+86', 'CNY', 'Chinese Yuan', 'يوان صيني', '¥', 'Asia', 'Asia', 'Eastern Asia', 'Beijing', 'بكين'),
('India', 'الهند', 'IN', 'IND', 356, '+91', 'INR', 'Indian Rupee', 'روبية هندية', '₹', 'Asia', 'Asia', 'Southern Asia', 'New Delhi', 'نيودلهي'),
('Brazil', 'البرازيل', 'BR', 'BRA', 76, '+55', 'BRL', 'Brazilian Real', 'ريال برازيلي', 'R$', 'South America', 'Americas', 'South America', 'Brasília', 'برازيليا'),
('Russia', 'روسيا', 'RU', 'RUS', 643, '+7', 'RUB', 'Russian Ruble', 'روبل روسي', '₽', 'Europe', 'Europe', 'Eastern Europe', 'Moscow', 'موسكو'),
('Turkey', 'تركيا', 'TR', 'TUR', 792, '+90', 'TRY', 'Turkish Lira', 'ليرة تركية', '₺', 'Europe', 'Asia', 'Western Asia', 'Ankara', 'أنقرة'),
('Spain', 'إسبانيا', 'ES', 'ESP', 724, '+34', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Southern Europe', 'Madrid', 'مدريد'),
('Italy', 'إيطاليا', 'IT', 'ITA', 380, '+39', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Southern Europe', 'Rome', 'روما'),
('Netherlands', 'هولندا', 'NL', 'NLD', 528, '+31', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Western Europe', 'Amsterdam', 'أمستردام'),
('Belgium', 'بلجيكا', 'BE', 'BEL', 56, '+32', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Western Europe', 'Brussels', 'بروكسل'),
('Switzerland', 'سويسرا', 'CH', 'CHE', 756, '+41', 'CHF', 'Swiss Franc', 'فرنك سويسري', 'CHF', 'Europe', 'Europe', 'Western Europe', 'Bern', 'برن'),
('Sweden', 'السويد', 'SE', 'SWE', 752, '+46', 'SEK', 'Swedish Krona', 'كرونا سويدية', 'kr', 'Europe', 'Europe', 'Northern Europe', 'Stockholm', 'ستوكهولم'),
('Norway', 'النرويج', 'NO', 'NOR', 578, '+47', 'NOK', 'Norwegian Krone', 'كرونة نرويجية', 'kr', 'Europe', 'Europe', 'Northern Europe', 'Oslo', 'أوسلو'),
('Denmark', 'الدنمارك', 'DK', 'DNK', 208, '+45', 'DKK', 'Danish Krone', 'كرونة دنماركية', 'kr', 'Europe', 'Europe', 'Northern Europe', 'Copenhagen', 'كوبنهاغن'),
('Finland', 'فنلندا', 'FI', 'FIN', 246, '+358', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Northern Europe', 'Helsinki', 'هلسنكي'),
('Poland', 'بولندا', 'PL', 'POL', 616, '+48', 'PLN', 'Polish Zloty', 'زلوتي بولندي', 'zł', 'Europe', 'Europe', 'Eastern Europe', 'Warsaw', 'وارسو'),
('South Korea', 'كوريا الجنوبية', 'KR', 'KOR', 410, '+82', 'KRW', 'South Korean Won', 'وون كوري جنوبي', '₩', 'Asia', 'Asia', 'Eastern Asia', 'Seoul', 'سول'),
('Singapore', 'سنغافورة', 'SG', 'SGP', 702, '+65', 'SGD', 'Singapore Dollar', 'دولار سنغافوري', '$', 'Asia', 'Asia', 'South-Eastern Asia', 'Singapore', 'سنغافورة'),
('Malaysia', 'ماليزيا', 'MY', 'MYS', 458, '+60', 'MYR', 'Malaysian Ringgit', 'رينغيت ماليزي', 'RM', 'Asia', 'Asia', 'South-Eastern Asia', 'Kuala Lumpur', 'كوالالمبور'),
('Indonesia', 'إندونيسيا', 'ID', 'IDN', 360, '+62', 'IDR', 'Indonesian Rupiah', 'روبية إندونيسية', 'Rp', 'Asia', 'Asia', 'South-Eastern Asia', 'Jakarta', 'جاكرتا'),
('Thailand', 'تايلاند', 'TH', 'THA', 764, '+66', 'THB', 'Thai Baht', 'بات تايلندي', '฿', 'Asia', 'Asia', 'South-Eastern Asia', 'Bangkok', 'بانكوك'),
('Vietnam', 'فيتنام', 'VN', 'VNM', 704, '+84', 'VND', 'Vietnamese Dong', 'دونغ فيتنامي', '₫', 'Asia', 'Asia', 'South-Eastern Asia', 'Hanoi', 'هانوي'),
('Philippines', 'الفلبين', 'PH', 'PHL', 608, '+63', 'PHP', 'Philippine Peso', 'بيزو فلبيني', '₱', 'Asia', 'Asia', 'South-Eastern Asia', 'Manila', 'مانيلا'),
('Pakistan', 'باكستان', 'PK', 'PAK', 586, '+92', 'PKR', 'Pakistani Rupee', 'روبية باكستانية', '₨', 'Asia', 'Asia', 'Southern Asia', 'Islamabad', 'إسلام آباد'),
('Bangladesh', 'بنغلاديش', 'BD', 'BGD', 50, '+880', 'BDT', 'Bangladeshi Taka', 'تاكا بنغلاديشي', '৳', 'Asia', 'Asia', 'Southern Asia', 'Dhaka', 'دكا'),
('Nigeria', 'نيجيريا', 'NG', 'NGA', 566, '+234', 'NGN', 'Nigerian Naira', 'نايرا نيجيري', '₦', 'Africa', 'Africa', 'Western Africa', 'Abuja', 'أبوجا'),
('South Africa', 'جنوب أفريقيا', 'ZA', 'ZAF', 710, '+27', 'ZAR', 'South African Rand', 'راند جنوب أفريقي', 'R', 'Africa', 'Africa', 'Southern Africa', 'Pretoria', 'بريتوريا'),
('Mexico', 'المكسيك', 'MX', 'MEX', 484, '+52', 'MXN', 'Mexican Peso', 'بيزو مكسيكي', '$', 'North America', 'Americas', 'Northern America', 'Mexico City', 'مدينة مكسيكو'),
('Argentina', 'الأرجنتين', 'AR', 'ARG', 32, '+54', 'ARS', 'Argentine Peso', 'بيزو أرجنتيني', '$', 'South America', 'Americas', 'South America', 'Buenos Aires', 'بوينس آيرس'),
('Colombia', 'كولومبيا', 'CO', 'COL', 170, '+57', 'COP', 'Colombian Peso', 'بيزو كولومبي', '$', 'South America', 'Americas', 'South America', 'Bogotá', 'بوغوتا'),
('Chile', 'تشيلي', 'CL', 'CHL', 152, '+56', 'CLP', 'Chilean Peso', 'بيزو تشيلي', '$', 'South America', 'Americas', 'South America', 'Santiago', 'سانتياغو'),
('Peru', 'بيرو', 'PE', 'PER', 604, '+51', 'PEN', 'Peruvian Sol', 'سول بيروفي', 'S/.', 'South America', 'Americas', 'South America', 'Lima', 'ليما'),
('Venezuela', 'فنزويلا', 'VE', 'VEN', 862, '+58', 'VES', 'Venezuelan Bolívar', 'بوليفار فنزويلي', 'Bs.', 'South America', 'Americas', 'South America', 'Caracas', 'كاراكاس'),
('Greece', 'اليونان', 'GR', 'GRC', 300, '+30', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Southern Europe', 'Athens', 'أثينا'),
('Portugal', 'البرتغال', 'PT', 'PRT', 620, '+351', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Southern Europe', 'Lisbon', 'ليسبون'),
('Ireland', 'أيرلندا', 'IE', 'IRL', 372, '+353', 'EUR', 'Euro', 'يورو', '€', 'Europe', 'Europe', 'Northern Europe', 'Dublin', 'دبلن'),
('New Zealand', 'نيوزيلندا', 'NZ', 'NZL', 554, '+64', 'NZD', 'New Zealand Dollar', 'دولار نيوزيلندي', '$', 'Oceania', 'Oceania', 'Australia and New Zealand', 'Wellington', 'ويلينغتون'),
('South Sudan', 'جنوب السودان', 'SS', 'SSD', 728, '+211', 'SSP', 'South Sudanese Pound', 'جنيه جنوب سوداني', '£', 'Africa', 'Africa', 'Northern Africa', 'Juba', 'جوبا'),
('Libya', 'ليبيا', 'LY', 'LBY', 434, '+218', 'LYD', 'Libyan Dinar', 'دينار ليبي', 'ل.د', 'Africa', 'Africa', 'Northern Africa', 'Tripoli', 'طرابلس'),
('Jordan', 'الأردن', 'JO', 'JOR', 400, '+962', 'JOD', 'Jordanian Dinar', 'دينار أردني', 'د.أ', 'Asia', 'Asia', 'Western Asia', 'Amman', 'عمان'),
('Lebanon', 'لبنان', 'LB', 'LBN', 422, '+961', 'LBP', 'Lebanese Pound', 'ليرة لبنانية', 'ل.ل', 'Asia', 'Asia', 'Western Asia', 'Beirut', 'بيروت'),
('Syria', 'سوريا', 'SY', 'SYR', 760, '+963', 'SYP', 'Syrian Pound', 'ليرة سورية', 'ل.س', 'Asia', 'Asia', 'Western Asia', 'Damascus', 'دمشق'),
('Iraq', 'العراق', 'IQ', 'IRQ', 368, '+964', 'IQD', 'Iraqi Dinar', 'دينار عراقي', 'ع.د', 'Asia', 'Asia', 'Western Asia', 'Baghdad', 'بغداد'),
('Yemen', 'اليمن', 'YE', 'YEM', 887, '+967', 'YER', 'Yemeni Rial', 'ريال يمني', 'ر.ي', 'Asia', 'Asia', 'Western Asia', 'Sana''a', 'صنعاء'),
('Oman', 'عمان', 'OM', 'OMN', 512, '+968', 'OMR', 'Omani Rial', 'ريال عماني', 'ر.ع', 'Asia', 'Asia', 'Western Asia', 'Muscat', 'مسقط'),
('Bahrain', 'البحرين', 'BH', 'BHR', 48, '+973', 'BHD', 'Bahraini Dinar', 'دينار بحريني', 'د.ب', 'Asia', 'Asia', 'Western Asia', 'Manama', 'المنامة'),
('Palestin', 'قلسطين', 'PS', 'PSE ', 376, '+972', 'PSE', 'Palestiny New Shekel', 'شيكل فلسطيني جديد', '₪', 'Asia', 'Asia', 'Western Asia', 'Jerusalem', 'القدس'),
('Palestine', 'فلسطين', 'PS', 'PSE', 275, '+970', 'PSE', 'Palestini New Shekel', 'شيكل فلسطيني جديد', '₪', 'Asia', 'Asia', 'Western Asia', 'Ramallah', 'رام الله')
ON CONFLICT (iso2_code) DO NOTHING;
-- Migration: Create Regions Table
-- Purpose: Store region/state/province reference data within countries
-- Version: v2_P01_003
-- Created: 2026-03-04
-- Dependencies: v2_P01_002_create_countries_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Regions Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create regions table to store region/state/province reference data
CREATE TABLE IF NOT EXISTS regions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  country_id UUID NOT NULL REFERENCES countries(id) ON DELETE CASCADE,

  -- Region Information
  name VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255),
  code VARCHAR(10) NOT NULL,  -- Region code (e.g., ALG for Algiers)
  iso_code VARCHAR(10),       -- ISO subdivision code if available
  region_type VARCHAR(50),    -- State, Province, Region, Governorate, etc.
  capital VARCHAR(100),       -- Capital city of the region
  capital_ar VARCHAR(100),

  -- Geographic Information
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),

  -- Status and Metadata
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_supported BOOLEAN NOT NULL DEFAULT true,  -- Whether app supports this region

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_region_code CHECK (code ~ '^[A-Z0-9]{2,10}$'),
  CONSTRAINT unique_country_region UNIQUE (country_id, code)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_regions_country_id ON regions(country_id) WHERE is_active = true;
CREATE INDEX idx_regions_code ON regions(code) WHERE is_active = true;
CREATE INDEX idx_regions_name ON regions(name) WHERE is_active = true;
CREATE INDEX idx_regions_is_active ON regions(is_active);
CREATE INDEX idx_regions_is_supported ON regions(is_supported) WHERE is_supported = true;
CREATE INDEX idx_regions_country_code ON regions(country_id, code) WHERE is_active = true;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on regions table
ALTER TABLE regions ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active regions
CREATE POLICY "Active regions are viewable by everyone"
  ON regions FOR SELECT
  USING (is_active = true);

-- Policy: Everyone can view supported regions
CREATE POLICY "Supported regions are viewable by everyone"
  ON regions FOR SELECT
  USING (is_supported = true);

-- Policy: Super admins can manage regions
-- Note: This policy will be updated after users table is created
-- For now, allow service role to manage regions
CREATE POLICY "Service role can manage regions"
  ON regions FOR ALL
  USING (auth.role() = 'service_role');

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_regions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER regions_update_updated_at
  BEFORE UPDATE ON regions
  FOR EACH ROW
  EXECUTE FUNCTION update_regions_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE regions IS 'Region/state/province reference data within countries';
COMMENT ON COLUMN regions.id IS 'Primary key (UUID)';
COMMENT ON COLUMN regions.country_id IS 'Foreign key reference to countries table';
COMMENT ON COLUMN regions.name IS 'Region name in English';
COMMENT ON COLUMN regions.name_ar IS 'Region name in Arabic';
COMMENT ON COLUMN regions.code IS 'Region code (e.g., ALG for Algiers)';
COMMENT ON COLUMN regions.iso_code IS 'ISO subdivision code if available';
COMMENT ON COLUMN regions.region_type IS 'Type of region (State, Province, Region, Governorate, etc.)';
COMMENT ON COLUMN regions.capital IS 'Capital city of the region';
COMMENT ON COLUMN regions.capital_ar IS 'Capital city name in Arabic';
COMMENT ON COLUMN regions.latitude IS 'Geographic latitude';
COMMENT ON COLUMN regions.longitude IS 'Geographic longitude';
COMMENT ON COLUMN regions.is_active IS 'Whether the region is active';
COMMENT ON COLUMN regions.is_supported IS 'Whether the app supports this region';

-- ══════════════════════════════════════════════════════════════════════════════
-- Seed Data
-- ══════════════════════════════════════════════════════════════════════════════

-- Insert Algerian regions (wilayas) - Primary market
INSERT INTO regions (country_id, name, name_ar, code, iso_code, region_type, capital, capital_ar, is_active, is_supported) VALUES
-- Get Algeria country ID
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Adrar', 'أدرار', '01', 'DZ-01', 'Wilaya', 'Adrar', 'أدرار', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Chlef', 'الشلف', '02', 'DZ-02', 'Wilaya', 'Chlef', 'الشلف', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Laghouat', 'الأغواط', '03', 'DZ-03', 'Wilaya', 'Laghouat', 'الأغواط', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Oum El Bouaghi', 'أم البواقي', '04', 'DZ-04', 'Wilaya', 'Oum El Bouaghi', 'أم البواقي', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Batna', 'باتنة', '05', 'DZ-05', 'Wilaya', 'Batna', 'باتنة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Béjaïa', 'بجاية', '06', 'DZ-06', 'Wilaya', 'Béjaïa', 'بجاية', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Biskra', 'بسكرة', '07', 'DZ-07', 'Wilaya', 'Biskra', 'بسكرة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Béchar', 'بشار', '08', 'DZ-08', 'Wilaya', 'Béchar', 'بشار', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Blida', 'البليدة', '09', 'DZ-09', 'Wilaya', 'Blida', 'البليدة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Bouira', 'البويرة', '10', 'DZ-10', 'Wilaya', 'Bouira', 'البويرة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tamanrasset', 'تمنراست', '11', 'DZ-11', 'Wilaya', 'Tamanrasset', 'تمنراست', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tébessa', 'تبسة', '12', 'DZ-12', 'Wilaya', 'Tébessa', 'تبسة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tlemcen', 'تلمسان', '13', 'DZ-13', 'Wilaya', 'Tlemcen', 'تلمسان', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tiaret', 'تيارت', '14', 'DZ-14', 'Wilaya', 'Tiaret', 'تيارت', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tizi Ouzou', 'تيزي وزو', '15', 'DZ-15', 'Wilaya', 'Tizi Ouzou', 'تيزي وزو', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Algiers', 'الجزائر', '16', 'DZ-16', 'Wilaya', 'Algiers', 'الجزائر', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Djelfa', 'الجلفة', '17', 'DZ-17', 'Wilaya', 'Djelfa', 'الجلفة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Jijel', 'جيجل', '18', 'DZ-18', 'Wilaya', 'Jijel', 'جيجل', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Sétif', 'سطيف', '19', 'DZ-19', 'Wilaya', 'Sétif', 'سطيف', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Saïda', 'سعيدة', '20', 'DZ-20', 'Wilaya', 'Saïda', 'سعيدة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Skikda', 'سكيكدة', '21', 'DZ-21', 'Wilaya', 'Skikda', 'سكيكدة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Sidi Bel Abbès', 'سيدي بلعباس', '22', 'DZ-22', 'Wilaya', 'Sidi Bel Abbès', 'سيدي بلعباس', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Annaba', 'عنابة', '23', 'DZ-23', 'Wilaya', 'Annaba', 'عنابة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Guelma', 'قالمة', '24', 'DZ-24', 'Wilaya', 'Guelma', 'قالمة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Constantine', 'قسنطينة', '25', 'DZ-25', 'Wilaya', 'Constantine', 'قسنطينة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Médéa', 'المدية', '26', 'DZ-26', 'Wilaya', 'Médéa', 'المدية', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Mostaganem', 'مستغانم', '27', 'DZ-27', 'Wilaya', 'Mostaganem', 'مستغانم', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'M''Sila', 'المسيلة', '28', 'DZ-28', 'Wilaya', 'M''Sila', 'المسيلة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Mascara', 'معسكر', '29', 'DZ-29', 'Wilaya', 'Mascara', 'معسكر', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Ouargla', 'ورقلة', '30', 'DZ-30', 'Wilaya', 'Ouargla', 'ورقلة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Oran', 'وهران', '31', 'DZ-31', 'Wilaya', 'Oran', 'وهران', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'El Bayadh', 'البيض', '32', 'DZ-32', 'Wilaya', 'El Bayadh', 'البيض', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Illizi', 'إليزي', '33', 'DZ-33', 'Wilaya', 'Illizi', 'إليزي', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Bordj Bou Arreridj', 'برج بوعريريج', '34', 'DZ-34', 'Wilaya', 'Bordj Bou Arreridj', 'برج بوعريريج', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Boumerdès', 'بومرداس', '35', 'DZ-35', 'Wilaya', 'Boumerdès', 'بومرداس', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'El Tarf', 'الطارف', '36', 'DZ-36', 'Wilaya', 'El Tarf', 'الطارف', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tindouf', 'تندوف', '37', 'DZ-37', 'Wilaya', 'Tindouf', 'تندوف', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tissemsilt', 'تيسمسيلت', '38', 'DZ-38', 'Wilaya', 'Tissemsilt', 'تيسمسيلت', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'El Oued', 'الوادي', '39', 'DZ-39', 'Wilaya', 'El Oued', 'الوادي', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Khenchela', 'خنشلة', '40', 'DZ-40', 'Wilaya', 'Khenchela', 'خنشلة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Souk Ahras', 'سوق أهراس', '41', 'DZ-41', 'Wilaya', 'Souk Ahras', 'سوق أهراس', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Tipaza', 'تيبازة', '42', 'DZ-42', 'Wilaya', 'Tipaza', 'تيبازة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Mila', 'ميلة', '43', 'DZ-43', 'Wilaya', 'Mila', 'ميلة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Aïn Defla', 'عين الدفلى', '44', 'DZ-44', 'Wilaya', 'Aïn Defla', 'عين الدفلى', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Naâma', 'النعامة', '45', 'DZ-45', 'Wilaya', 'Naâma', 'النعامة', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Aïn Témouchent', 'عين تموشنت', '46', 'DZ-46', 'Wilaya', 'Aïn Témouchent', 'عين تموشنت', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Ghardaïa', 'غرداية', '47', 'DZ-47', 'Wilaya', 'Ghardaïa', 'غرداية', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Relizane', 'غليزان', '48', 'DZ-48', 'Wilaya', 'Relizane', 'غليزان', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Timimoun', 'تيميمون', '49', 'DZ-49', 'Wilaya', 'Timimoun', 'تيميمون', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Bordj Badji Mokhtar', 'برج باجي مختار', '50', 'DZ-50', 'Wilaya', 'Bordj Badji Mokhtar', 'برج باجي مختار', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Ouled Djellal', 'أولاد جلال', '51', 'DZ-51', 'Wilaya', 'Ouled Djellal', 'أولاد جلال', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Béni Abbès', 'بني عباس', '52', 'DZ-52', 'Wilaya', 'Béni Abbès', 'بني عباس', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'In Salah', 'عين صالح', '53', 'DZ-53', 'Wilaya', 'In Salah', 'عين صالح', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'In Guezzam', 'عين قزام', '54', 'DZ-54', 'Wilaya', 'In Guezzam', 'عين قزام', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Touggourt', 'تقرت', '55', 'DZ-55', 'Wilaya', 'Touggourt', 'تقرت', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'Djanet', 'جانت', '56', 'DZ-56', 'Wilaya', 'Djanet', 'جانت', true, true
),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'El M''Ghair', 'المغير', '57', 'DZ-57', 'Wilaya', 'El M''Ghair', 'المغير', true, true),
(
  (SELECT id FROM countries WHERE iso2_code = 'DZ'),
  'El Meniaa', 'المنيعة', '58', 'DZ-58', 'Wilaya', 'El Meniaa', 'المنيعة', true, true
);
-- Migration: Create Users Table and Related Structures
-- Purpose: Define the users table with RLS policies and relationships to auth.users
-- Version: v2_P01_004
-- Created: 2026-03-04
-- Dependencies: None

-- ══════════════════════════════════════════════════════════════════════════════
-- Users Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create users table to store extended user profile information
-- This table extends Supabase's auth.users with application-specific fields
CREATE TABLE IF NOT EXISTS users (
  -- Primary and Foreign Keys
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- User Information
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  full_name VARCHAR(255) GENERATED ALWAYS AS (
    COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')
  ) STORED,

  -- Avatar and Profile Media
  avatar_url TEXT,  -- URL to user's profile picture
  bio TEXT,         -- User biography/description
  date_of_birth DATE,

  -- Business Information
  clinic_id UUID,   -- Reference to clinic (nullable - system admins don't have clinic)
  role user_role NOT NULL DEFAULT 'patient',

  -- Account Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_verified BOOLEAN NOT NULL DEFAULT false,  -- Email verified
  phone_verified BOOLEAN NOT NULL DEFAULT false,

  -- Contact and Location
  country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
  address TEXT,
  postal_code VARCHAR(20),
  city VARCHAR(100),

  -- Metadata and Preferences
  locale VARCHAR(5) DEFAULT 'en',  -- Language preference (en, ar)
  timezone VARCHAR(50) DEFAULT 'UTC',
  theme_preference VARCHAR(20) DEFAULT 'system',  -- light, dark, system
  two_factor_enabled BOOLEAN DEFAULT false,

  -- Subscription Information
  subscription_type subscription_type DEFAULT 'free',
  subscription_start_date TIMESTAMP WITH TIME ZONE,
  subscription_end_date TIMESTAMP WITH TIME ZONE,

  -- Activity Tracking
  last_login_at TIMESTAMP WITH TIME ZONE,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  login_count INTEGER DEFAULT 0,

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE,  -- Soft delete timestamp

  -- Constraints
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
  CONSTRAINT valid_phone CHECK (phone IS NULL OR phone ~* '^\+?[0-9\s\-\(\)]{10,}$'),
  CONSTRAINT valid_locale CHECK (locale IN ('en', 'ar')),
  CONSTRAINT valid_theme CHECK (theme_preference IN ('light', 'dark', 'system')),
  CONSTRAINT valid_subscription_dates CHECK (
    subscription_end_date IS NULL OR subscription_start_date IS NULL OR
    subscription_end_date >= subscription_start_date
  )
);

-- Create indexes for common queries
CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_clinic_id ON users(clinic_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_role ON users(role) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_is_active ON users(is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created_at ON users(created_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_subscription_type ON users(subscription_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_country_id ON users(country_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_region_id ON users(region_id) WHERE deleted_at IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Updated At Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER users_update_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ══════════════════════════════════════════════════════════════════════════════
-- Last Activity Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update last_activity_at on any table update
CREATE OR REPLACE FUNCTION update_user_last_activity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET last_activity_at = NOW() WHERE id = NEW.created_by OR id = NEW.updated_by;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read their own profile
CREATE POLICY users_read_own_profile ON users
  FOR SELECT
  USING (auth.uid() = id);

-- Policy: Super admins and clinic admins can read users in their clinic
CREATE POLICY admins_read_clinic_users ON users
  FOR SELECT
  USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('super_admin', 'clinic_admin')
    AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())
  );

-- Policy: Super admins can read all users
CREATE POLICY super_admin_read_all ON users
  FOR SELECT
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'super_admin');

-- Policy: Users can update only their own profile (non-sensitive fields)
CREATE POLICY users_update_own_profile ON users
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (
    auth.uid() = id
    AND role = (SELECT role FROM users WHERE id = auth.uid())  -- Prevent role change
    AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())  -- Prevent clinic change
  );

-- Policy: Clinic admins can update users in their clinic (limited fields)
CREATE POLICY admins_update_clinic_users ON users
  FOR UPDATE
  USING (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('super_admin', 'clinic_admin')
    AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())
  )
  WITH CHECK (
    (SELECT role FROM users WHERE id = auth.uid()) IN ('super_admin', 'clinic_admin')
    AND clinic_id = (SELECT clinic_id FROM users WHERE id = auth.uid())
  );

-- Policy: Users can insert their own profile after signup (new registrations)
CREATE POLICY users_insert_own_profile ON users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Policy: Only admins can delete users (soft delete via updated_at trigger)
CREATE POLICY admins_soft_delete ON users
  FOR UPDATE
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'super_admin')
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'super_admin');

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Views
-- ══════════════════════════════════════════════════════════════════════════════

-- View: Active users only (excluding soft-deleted)
CREATE VIEW active_users AS
SELECT * FROM users
WHERE deleted_at IS NULL;

-- View: Users by clinic (for clinic-specific queries)
CREATE VIEW clinic_users AS
SELECT u.*, 
  COUNT(*) OVER (PARTITION BY u.clinic_id) as clinic_user_count
FROM users u
WHERE u.deleted_at IS NULL
ORDER BY u.clinic_id, u.created_at;

-- View: User statistics
CREATE VIEW user_statistics AS
SELECT
  COUNT(*) as total_users,
  COUNT(CASE WHEN is_active THEN 1 END) as active_users,
  COUNT(CASE WHEN is_verified THEN 1 END) as verified_users,
  COUNT(DISTINCT clinic_id) as total_clinics,
  COUNT(CASE WHEN role = 'doctor' THEN 1 END) as doctor_count,
  COUNT(CASE WHEN role = 'patient' THEN 1 END) as patient_count,
  COUNT(CASE WHEN role = 'clinic_admin' THEN 1 END) as admin_count
FROM users
WHERE deleted_at IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE users IS 'Extended user profiles linked to Supabase auth.users';
COMMENT ON COLUMN users.id IS 'Foreign key reference to auth.users.id';
COMMENT ON COLUMN users.clinic_id IS 'Reference to clinics table (NULL for system admins)';
COMMENT ON COLUMN users.role IS 'User role determining permissions and access levels';
COMMENT ON COLUMN users.is_verified IS 'Email verification status';
COMMENT ON COLUMN users.two_factor_enabled IS 'Two-factor authentication status';
COMMENT ON COLUMN users.deleted_at IS 'Soft delete timestamp (NULL = active)';

COMMENT ON POLICY users_read_own_profile ON users IS 'Users can view their own profile only';
COMMENT ON POLICY admins_read_clinic_users ON users IS 'Admins can read users in their clinic';
COMMENT ON POLICY super_admin_read_all ON users IS 'Super admins can read all user profiles';
COMMENT ON POLICY users_update_own_profile ON users IS 'Users can update non-sensitive fields';
COMMENT ON POLICY admins_update_clinic_users ON users IS 'Admins can manage users in their clinic';

-- ══════════════════════════════════════════════════════════════════════════════
-- Migration Notes
-- ══════════════════════════════════════════════════════════════════════════════

/*
  IMPORTANT SETUP NOTES:

  1. This migration creates a 'users' table that extends Supabase's built-in auth.users
  2. The relationship is established via a foreign key on the 'id' column
  3. RLS (Row Level Security) is enabled to protect user data
  4. Four main policies control access:
     - Users can read their own profiles
     - Admins can manage clinic staff
     - Super admins have full access
     - Users can only update non-sensitive fields

  5. Soft-delete pattern: Use deleted_at IS NULL in WHERE clauses
  6. To fully delete a user: UPDATE users SET deleted_at = NOW() WHERE id = ...

  7. After creating auth.users, you must create a corresponding users record:
     - Use a trigger on auth.users.created_at, OR
     - Call a function during user registration signup

  8. Recommended post-signup function:
     CREATE FUNCTION handle_new_user() RETURNS TRIGGER AS $$
     BEGIN
       INSERT INTO users (id, email, role) VALUES (NEW.id, NEW.email, 'patient');
       RETURN NEW;
     END;
     $$ LANGUAGE plpgsql SECURITY DEFINER;

     CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users
     FOR EACH ROW EXECUTE FUNCTION handle_new_user();
*/
-- Migration: Create Specialties Table
-- Purpose: Store medical specialty reference data for doctors
-- Version: v2_P02_001
-- Created: 2026-03-04
-- Dependencies: None

-- ══════════════════════════════════════════════════════════════════════════════
-- Specialties Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create specialties table to store medical specialty reference data
CREATE TABLE IF NOT EXISTS specialties (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Specialty Information
  name_en VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255) NOT NULL,
  description_en TEXT,
  description_ar TEXT,
  
  -- Icon and Display
  icon_name VARCHAR(100),  -- Icon identifier for UI
  
  -- Ordering and Organization
  display_order INTEGER DEFAULT 0,
  category VARCHAR(100),  -- Medical, Surgical, Diagnostic, etc.
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_popular BOOLEAN NOT NULL DEFAULT false,  -- Popular specialties shown first
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_display_order CHECK (display_order >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_specialties_name_en ON specialties(name_en) WHERE is_active = true;
CREATE INDEX idx_specialties_name_ar ON specialties(name_ar) WHERE is_active = true;
CREATE INDEX idx_specialties_icon_name ON specialties(icon_name) WHERE is_active = true;
CREATE INDEX idx_specialties_category ON specialties(category) WHERE is_active = true;
CREATE INDEX idx_specialties_display_order ON specialties(display_order) WHERE is_active = true;
CREATE INDEX idx_specialties_is_popular ON specialties(is_popular) WHERE is_popular = true;
CREATE INDEX idx_specialties_is_active ON specialties(is_active);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on specialties table
ALTER TABLE specialties ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active specialties
CREATE POLICY "Active specialties are viewable by everyone"
  ON specialties FOR SELECT
  USING (is_active = true);

-- Policy: Super admins can manage specialties
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
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_specialties_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER specialties_update_updated_at
  BEFORE UPDATE ON specialties
  FOR EACH ROW
  EXECUTE FUNCTION update_specialties_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE specialties IS 'Medical specialty reference data for doctors';
COMMENT ON COLUMN specialties.id IS 'Primary key (UUID)';
COMMENT ON COLUMN specialties.name_en IS 'Specialty name in English';
COMMENT ON COLUMN specialties.name_ar IS 'Specialty name in Arabic';
COMMENT ON COLUMN specialties.description_en IS 'Description in English';
COMMENT ON COLUMN specialties.description_ar IS 'Description in Arabic';
COMMENT ON COLUMN specialties.icon_name IS 'Icon identifier for UI display';
COMMENT ON COLUMN specialties.display_order IS 'Display order for sorting';
COMMENT ON COLUMN specialties.category IS 'Specialty category (Medical, Surgical, Diagnostic, etc.)';
COMMENT ON COLUMN specialties.is_active IS 'Whether the specialty is active';
COMMENT ON COLUMN specialties.is_popular IS 'Whether this is a popular specialty';

-- ══════════════════════════════════════════════════════════════════════════════
-- Seed Data
-- ══════════════════════════════════════════════════════════════════════════════

-- Insert medical specialties
INSERT INTO specialties (name_en, name_ar, description_en, description_ar, icon_name, display_order, category, is_active, is_popular) VALUES
-- Popular specialties (shown first)
('General Practice', 'الطب العام', 'Comprehensive healthcare for individuals and families', 'رعاية صحية شاملة للأفراد والعائلات', 'medical_services', 1, 'Medical', true, true),
('Pediatrics', 'طب الأطفال', 'Medical care for infants, children, and adolescents', 'رعاية طبية للرضع والأطفال والمراهقين', 'child_care', 2, 'Medical', true, true),
('Internal Medicine', 'الطب الباطني', 'Diagnosis and treatment of adult diseases', 'تشخيص وعلاج أمراض البالغين', 'medical_services', 3, 'Medical', true, true),
('Cardiology', 'أمراض القلب', 'Diagnosis and treatment of heart diseases', 'تشخيص وعلاج أمراض القلب', 'cardiology', 4, 'Medical', true, true),
('Dermatology', 'الأمراض الجلدية', 'Treatment of skin, hair, and nail conditions', 'علاج أمراض الجلد والشعر والأظافر', 'dermatology', 5, 'Medical', true, true),
('Neurology', 'الأعصاب', 'Diagnosis and treatment of nervous system disorders', 'تشخيص وعلاج اضطرابات الجهاز العصبي', 'neurology', 6, 'Medical', true, true),
('Orthopedics', 'العظام', 'Treatment of musculoskeletal system disorders', 'علاج اضطرابات الجهاز العضلي الهيكلي', 'orthopedics', 7, 'Medical', true, true),
('Ophthalmology', 'طب العيون', 'Eye care and surgery', 'رعاية العيون والجراحة', 'ophthalmology', 8, 'Medical', true, true),
('Obstetrics and Gynecology', 'أمراض النساء والتوليد', 'Women''s reproductive health and childbirth', 'الصحة الإنجابية للنساء والولادة', 'pregnant_woman', 9, 'Medical', true, true),
('Psychiatry', 'الطب النفسي', 'Mental health and behavioral disorders', 'الصحة النفسية والاضطرابات السلوكية', 'psychology', 10, 'Medical', true, true),

-- Medical specialties
('Endocrinology', 'الغدد الصماء', 'Hormonal disorders and diabetes', 'اضطرابات هرمونية والسكري', 'medical_services', 11, 'Medical', true, false),
('Gastroenterology', 'أمراض الجهاز الهضمي', 'Digestive system disorders', 'اضطرابات الجهاز الهضمي', 'medical_services', 12, 'Medical', true, false),
('Nephrology', 'أمراض الكلى', 'Kidney diseases and dialysis', 'أمراض الكلى وغسيل الكلى', 'medical_services', 13, 'Medical', true, false),
('Pulmonology', 'أمراض الرئة', 'Respiratory system diseases', 'أمراض الجهاز التنفسي', 'medical_services', 14, 'Medical', true, false),
('Rheumatology', 'أمراض الروماتيزم', 'Autoimmune and rheumatic diseases', 'أمراض المناعة الذاتية والروماتيزم', 'medical_services', 15, 'Medical', true, false),
('Hematology', 'أمراض الدم', 'Blood disorders and cancers', 'أمراض الدم والسرطانات', 'medical_services', 16, 'Medical', true, false),
('Oncology', 'الأورام', 'Cancer diagnosis and treatment', 'تشخيص وعلاج السرطان', 'medical_services', 17, 'Medical', true, false),
('Infectious Diseases', 'الأمراض المعدية', 'Infections and tropical diseases', 'العدوى والأمراض الاستوائية', 'medical_services', 18, 'Medical', true, false),
('Geriatrics', 'طب المسنين', 'Healthcare for elderly patients', 'رعاية صحية للمسنين', 'medical_services', 19, 'Medical', true, false),
('Allergy and Immunology', 'الحساسية والمناعة', 'Allergies and immune system disorders', 'الحساسية واضطرابات الجهاز المناعي', 'medical_services', 20, 'Medical', true, false),

-- Surgical specialties
('General Surgery', 'الجراحة العامة', 'Common surgical procedures', 'الإجراءات الجراحية الشائعة', 'surgery', 21, 'Surgical', true, false),
('Neurosurgery', 'جراحة المخ والأعصاب', 'Brain and nervous system surgery', 'جراحة الدماغ والجهاز العصبي', 'neurosurgery', 22, 'Surgical', true, false),
('Cardiothoracic Surgery', 'جراحة القلب والصدر', 'Heart and chest surgery', 'جراحة القلب والصدر', 'cardiology', 23, 'Surgical', true, false),
('Vascular Surgery', 'جراحة الأوعية الدموية', 'Blood vessel surgery', 'جراحة الأوعية الدموية', 'vascular_surgery', 24, 'Surgical', true, false),
('Plastic Surgery', 'الجراحة التجميلية', 'Reconstructive and cosmetic surgery', 'الجراحة الترميمية والتجميلية', 'plastic_surgery', 25, 'Surgical', true, false),
('Pediatric Surgery', 'جراحة الأطفال', 'Surgery for infants and children', 'جراحة للرضع والأطفال', 'surgery', 26, 'Surgical', true, false),
('Urology', 'جراحة المسالك البولية', 'Urinary tract and male reproductive system', 'المسالك البولية والجهاز التناسلي الذكري', 'medical_services', 27, 'Surgical', true, false),
('Oral and Maxillofacial Surgery', 'جراحة الفم والوجه والفكين', 'Mouth, face, and jaw surgery', 'جراحة الفم والوجه والفكين', 'surgery', 28, 'Surgical', true, false),

-- Diagnostic specialties
('Radiology', 'الأشعة', 'Medical imaging and diagnosis', 'التصوير الطبي والتشخيص', 'radiology', 29, 'Diagnostic', true, false),
('Pathology', 'علم الأمراض', 'Disease diagnosis through laboratory analysis', 'تشخيص الأمراض من خلال التحليل المخبري', 'medical_services', 30, 'Diagnostic', true, false),
('Clinical Pathology', 'علم الأمراض السريري', 'Laboratory medicine and diagnostics', 'الطب المخبري والتشخيص', 'medical_services', 31, 'Diagnostic', true, false),
('Anatomic Pathology', 'علم الأمراض التشريحي', 'Tissue and cell analysis', 'تحليل الأنسجة والخلايا', 'medical_services', 32, 'Diagnostic', true, false),
('Nuclear Medicine', 'الطب النووي', 'Radioactive substances for diagnosis and treatment', 'المواد المشعة للتشخيص والعلاج', 'medical_services', 33, 'Diagnostic', true, false),

-- Other specialties
('Anesthesiology', 'التخدير', 'Anesthesia and pain management', 'التخدير وإدارة الألم', 'anesthesiology', 34, 'Medical', true, false),
('Emergency Medicine', 'طب الطوارئ', 'Immediate medical care for acute conditions', 'رعاية طبية فورية للحالات الحادة', 'emergency_medical_services', 35, 'Medical', true, false),
('Family Medicine', 'الطب العائلي', 'Comprehensive healthcare for families', 'رعاية صحية شاملة للعائلات', 'family_restroom', 36, 'Medical', true, false),
('Preventive Medicine', 'الطب الوقائي', 'Disease prevention and health promotion', 'الوقاية من الأمراض وتعزيز الصحة', 'medical_services', 37, 'Medical', true, false),
('Sports Medicine', 'الطب الرياضي', 'Sports injuries and performance', 'إصابات الرياضات والأداء', 'sports', 38, 'Medical', true, false),
('Occupational Medicine', 'الطب المهني', 'Workplace health and safety', 'الصحة والسلامة في مكان العمل', 'medical_services', 39, 'Medical', true, false),
('Physical Medicine and Rehabilitation', 'الطب الطبيعي والتأهيل', 'Physical therapy and rehabilitation', 'العلاج الطبيعي والتأهيل', 'medical_services', 40, 'Medical', true, false),
('Medical Genetics', 'الطب الوراثي', 'Genetic disorders and counseling', 'الاضطرابات الوراثية والاستشارة', 'medical_services', 41, 'Medical', true, false),
('Palliative Care', 'الرعاية التلطيفية', 'Symptom relief for serious illnesses', 'تخفيف الأعراض للأمراض الخطيرة', 'medical_services', 42, 'Medical', true, false),
('Sleep Medicine', 'طب النوم', 'Sleep disorders and breathing problems', 'اضطرابات النوم ومشاكل التنفس', 'medical_services', 43, 'Medical', true, false),

-- Dental specialties (if applicable)
('Dentistry', 'طب الأسنان', 'Oral health and dental care', 'الصحة الفموية ورعاية الأسنان', 'medical_services', 44, 'Medical', true, false),
('Oral Surgery', 'جراحة الفم', 'Surgical procedures in the mouth', 'الإجراءات الجراحية في الفم', 'surgery', 45, 'Surgical', true, false),
('Orthodontics', 'تقويم الأسنان', 'Teeth and jaw alignment', 'محاذاة الأسنان والفك', 'medical_services', 46, 'Medical', true, false),
('Periodontics', 'أمراض اللثة', 'Gum disease treatment', 'علاج أمراض اللثة', 'medical_services', 47, 'Medical', true, false),
('Endodontics', 'علاج قناة الجذر', 'Root canal therapy', 'علاج قناة الجذر', 'medical_services', 48, 'Medical', true, false),

-- Mental Health specialties
('Clinical Psychology', 'علم النفس السريري', 'Diagnosis and treatment of mental disorders', 'تشخيص وعلاج الاضطرابات النفسية', 'psychology', 49, 'Medical', true, false),
('Counseling Psychology', 'علم النفس الإرشادي', 'Mental health counseling', 'الإرشاد النفسي', 'psychology', 50, 'Medical', true, false),
('Child and Adolescent Psychiatry', 'طب نفس الأطفال والمراهقين', 'Mental health for children and teens', 'الصحة النفسية للأطفال والمراهقين', 'psychology', 51, 'Medical', true, false),
('Addiction Psychiatry', 'طب الإدمان', 'Substance abuse treatment', 'علاج إساءة استخدام المواد', 'psychology', 52, 'Medical', true, false),

-- Specialized care
('Autism Spectrum Disorder', 'اضطراب طيف التوحد', 'Autism diagnosis and treatment', 'تشخيص وعلاج التوحد', 'medical_services', 53, 'Medical', true, false),
('Developmental Pediatrics', 'طب النمو والتطور', 'Child development and delays', 'نمو الطفل والتأخيرات', 'child_care', 54, 'Medical', true, false),
('Neurodevelopmental Disorders', 'اضطرابات النمو العصبي', 'ADHD, learning disabilities, etc.', 'اضطراب نقص الانتباه، صعوبات التعلم، إلخ', 'medical_services', 55, 'Medical', true, false),
('Epilepsy', 'الصرع', 'Seizure disorders', 'اضطرابات النوبات', 'neurology', 56, 'Medical', true, false),
('Stroke Medicine', 'طب السكتة الدماغية', 'Stroke prevention and treatment', 'الوقاية من السكتة الدماغية وعلاجها', 'neurology', 57, 'Medical', true, false),
('Pain Management', 'إدارة الألم', 'Chronic pain treatment', 'علاج الألم المزمن', 'medical_services', 58, 'Medical', true, false);

-- Create unique index on English names
CREATE UNIQUE INDEX idx_specialties_name_en_unique ON specialties(name_en) WHERE is_active = true;
-- Migration: Create Clinics Table
-- Purpose: Store medical clinic information
-- Version: v2_P02_002
-- Created: 2026-03-04
-- Dependencies: v2_P01_002_create_countries_table.sql, v2_P01_003_create_regions_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Clinics Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create clinics table to store medical clinic information
CREATE TABLE IF NOT EXISTS clinics (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Clinic Information
  name VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255),
  description TEXT,
  description_ar TEXT,
  
  -- Contact Information
  address TEXT NOT NULL,
  city VARCHAR(100) NOT NULL,
  region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
  country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(255),
  website VARCHAR(255),
  
  -- Branding and Media
  logo_url TEXT,
  banner_url TEXT,
  
  -- Operating Hours
  opening_hours JSONB,  -- JSON object with daily hours
  
  -- Geographic Location
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  
  -- Subscription Information
  subscription_id UUID,  -- Reference to subscription_codes table
  subscription_type subscription_type DEFAULT 'trial',
  subscription_start_date TIMESTAMP WITH TIME ZONE,
  subscription_end_date TIMESTAMP WITH TIME ZONE,
  is_trial BOOLEAN DEFAULT true,
  

  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,  -- Featured clinics shown prominently
  
  -- Statistics
  total_patients INTEGER DEFAULT 0,
  total_doctors INTEGER DEFAULT 0,
  total_appointments INTEGER DEFAULT 0,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_latitude CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
  CONSTRAINT valid_longitude CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180),
  CONSTRAINT valid_phone CHECK (phone ~* '^\+?[0-9\s\-\(\)]{10,}$'),
  CONSTRAINT valid_email CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_clinics_region_id ON clinics(region_id) WHERE is_active = true;
CREATE INDEX idx_clinics_country_id ON clinics(country_id) WHERE is_active = true;
CREATE INDEX idx_clinics_subscription_id ON clinics(subscription_id);
CREATE INDEX idx_clinics_is_active ON clinics(is_active);
CREATE INDEX idx_clinics_is_verified ON clinics(is_verified);
CREATE INDEX idx_clinics_is_featured ON clinics(is_featured) WHERE is_featured = true;
CREATE INDEX idx_clinics_created_at ON clinics(created_at DESC);
CREATE INDEX idx_clinics_name ON clinics(name) WHERE is_active = true;
CREATE INDEX idx_clinics_city ON clinics(city) WHERE is_active = true;
CREATE INDEX idx_clinics_subscription_type ON clinics(subscription_type) WHERE is_active = true;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on clinics table
ALTER TABLE clinics ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active and verified clinics
CREATE POLICY "Active verified clinics are viewable by everyone"
  ON clinics FOR SELECT
  USING (is_active = true AND is_verified = true);

-- Policy: Clinic owners can view their own clinic
CREATE POLICY "Clinic owners can view their clinic"
  ON clinics FOR SELECT
  USING (created_by = auth.uid());

-- Policy: Clinic owners can update their clinic
CREATE POLICY "Clinic owners can update their clinic"
  ON clinics FOR UPDATE
  USING (created_by = auth.uid());

-- Policy: Clinic owners can delete their clinic
CREATE POLICY "Clinic owners can delete their clinic"
  ON clinics FOR DELETE
  USING (created_by = auth.uid());

-- Policy: Super admins can manage all clinics
CREATE POLICY "Super admins can manage all clinics"
  ON clinics FOR ALL
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
CREATE OR REPLACE FUNCTION update_clinics_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER clinics_update_updated_at
  BEFORE UPDATE ON clinics
  FOR EACH ROW
  EXECUTE FUNCTION update_clinics_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE clinics IS 'Medical clinic information';
COMMENT ON COLUMN clinics.id IS 'Primary key (UUID)';
COMMENT ON COLUMN clinics.name IS 'Clinic name in English';
COMMENT ON COLUMN clinics.name_ar IS 'Clinic name in Arabic';
COMMENT ON COLUMN clinics.address IS 'Physical address';
COMMENT ON COLUMN clinics.city IS 'City name';
COMMENT ON COLUMN clinics.region_id IS 'Foreign key reference to regions table';
COMMENT ON COLUMN clinics.country_id IS 'Foreign key reference to countries table';
COMMENT ON COLUMN clinics.opening_hours IS 'JSON object containing opening hours for each day of the week';
COMMENT ON COLUMN clinics.latitude IS 'Geographic latitude for map display';
COMMENT ON COLUMN clinics.longitude IS 'Geographic longitude for map display';
COMMENT ON COLUMN clinics.subscription_id IS 'Foreign key reference to subscription_codes table';
COMMENT ON COLUMN clinics.subscription_type IS 'Type of subscription plan';
COMMENT ON COLUMN clinics.is_trial IS 'Whether this is a trial subscription';
COMMENT ON COLUMN clinics.is_active IS 'Whether the clinic is active';
COMMENT ON COLUMN clinics.is_verified IS 'Whether the clinic has been verified';
COMMENT ON COLUMN clinics.is_featured IS 'Whether this clinic is featured';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to check if clinic subscription is expired
CREATE OR REPLACE FUNCTION is_clinic_subscription_expired(clinic_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  SELECT subscription_end_date INTO end_date
  FROM clinics
  WHERE id = clinic_id;
  
  RETURN end_date IS NULL OR end_date < NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to get days remaining in subscription
CREATE OR REPLACE FUNCTION get_clinic_subscription_days_remaining(clinic_id UUID)
RETURNS INTEGER AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  SELECT subscription_end_date INTO end_date
  FROM clinics
  WHERE id = clinic_id;
  
  IF end_date IS NULL THEN
    RETURN 0;
  END IF;
  
  RETURN GREATEST(0, EXTRACT(DAY FROM (end_date - NOW()))::INTEGER);
END;
$$ LANGUAGE plpgsql;

-- Function to check if subscription is expiring soon (within 7 days)
CREATE OR REPLACE FUNCTION is_clinic_subscription_expiring_soon(clinic_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  days_remaining INTEGER;
BEGIN
  days_remaining := get_clinic_subscription_days_remaining(clinic_id);
  RETURN days_remaining <= 7 AND days_remaining >= 0;
END;
$$ LANGUAGE plpgsql;
-- Migration: Create Subscriptions Table
-- Purpose: Store clinic subscription information
-- Version: v2_P02_003
-- Created: 2026-03-04
-- Dependencies: None

-- ══════════════════════════════════════════════════════════════════════════════
-- Subscriptions Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create subscriptions table to store clinic subscription information
CREATE TABLE IF NOT EXISTS subscriptions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Subscription Information
  code VARCHAR(50) NOT NULL UNIQUE,  -- Unique subscription code
  type subscription_type NOT NULL,
  
  -- Pricing (Multi-currency)
  price_usd DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  price_eur DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  price_dzd DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  
  -- Duration
  duration_days INTEGER NOT NULL,
  
  -- Usage Tracking
  is_used BOOLEAN NOT NULL DEFAULT false,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  used_at TIMESTAMP WITH TIME ZONE,
  used_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Activation Details
  activated_at TIMESTAMP WITH TIME ZONE,
  activation_notes TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_expired BOOLEAN NOT NULL DEFAULT false,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_duration CHECK (duration_days > 0),
  CONSTRAINT valid_price_usd CHECK (price_usd >= 0),
  CONSTRAINT valid_price_eur CHECK (price_eur >= 0),
  CONSTRAINT valid_price_dzd CHECK (price_dzd >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_subscriptions_code ON subscriptions(code);
CREATE INDEX idx_subscriptions_type ON subscriptions(type);
CREATE INDEX idx_subscriptions_clinic_id ON subscriptions(clinic_id);
CREATE INDEX idx_subscriptions_is_used ON subscriptions(is_used);
CREATE INDEX idx_subscriptions_is_active ON subscriptions(is_active);
CREATE INDEX idx_subscriptions_is_expired ON subscriptions(is_expired);
CREATE INDEX idx_subscriptions_created_at ON subscriptions(created_at DESC);
CREATE INDEX idx_subscriptions_used_at ON subscriptions(used_at);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on subscriptions table
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Policy: Super admins can manage all subscriptions
CREATE POLICY "Super admins can manage all subscriptions"
  ON subscriptions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Policy: Clinic admins can view their clinic subscriptions
CREATE POLICY "Clinic admins can view their clinic subscriptions"
  ON subscriptions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM users WHERE id = auth.uid()
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_subscriptions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER subscriptions_update_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_subscriptions_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE subscriptions IS 'Clinic subscription information';
COMMENT ON COLUMN subscriptions.id IS 'Primary key (UUID)';
COMMENT ON COLUMN subscriptions.code IS 'Unique subscription code';
COMMENT ON COLUMN subscriptions.type IS 'Type of subscription plan';
COMMENT ON COLUMN subscriptions.price_usd IS 'Price in US Dollars';
COMMENT ON COLUMN subscriptions.price_eur IS 'Price in Euros';
COMMENT ON COLUMN subscriptions.price_dzd IS 'Price in Algerian Dinars';
COMMENT ON COLUMN subscriptions.duration_days IS 'Duration in days';
COMMENT ON COLUMN subscriptions.is_used IS 'Whether the subscription code has been used';
COMMENT ON COLUMN subscriptions.clinic_id IS 'Foreign key reference to clinics table';
COMMENT ON COLUMN subscriptions.used_at IS 'Timestamp when the subscription was used';
COMMENT ON COLUMN subscriptions.is_active IS 'Whether the subscription is active';
COMMENT ON COLUMN subscriptions.is_expired IS 'Whether the subscription has expired';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Drop any conflicting functions from clinics migration
DROP FUNCTION IF EXISTS is_subscription_expired(UUID) CASCADE;
DROP FUNCTION IF EXISTS get_subscription_days_remaining(UUID) CASCADE;

-- Function to calculate subscription end date
CREATE OR REPLACE FUNCTION get_subscription_end_date(subscription_id UUID)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
  activation_date TIMESTAMP WITH TIME ZONE;
  duration_days INTEGER;
BEGIN
  SELECT activated_at, duration_days INTO activation_date, duration_days
  FROM subscriptions
  WHERE id = subscription_id;
  
  IF activation_date IS NULL OR duration_days IS NULL THEN
    RETURN NULL;
  END IF;
  
  RETURN activation_date + (duration_days || ' days')::INTERVAL;
END;
$$ LANGUAGE plpgsql;

-- Function to check if subscription is expired
CREATE OR REPLACE FUNCTION is_subscription_expired(subscription_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  end_date := get_subscription_end_date(subscription_id);
  
  IF end_date IS NULL THEN
    RETURN false;
  END IF;
  
  RETURN end_date < NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to get days remaining in subscription
CREATE OR REPLACE FUNCTION get_subscription_days_remaining(subscription_id UUID)
RETURNS INTEGER AS $$
DECLARE
  end_date TIMESTAMP WITH TIME ZONE;
BEGIN
  end_date := get_subscription_end_date(subscription_id);
  
  IF end_date IS NULL THEN
    RETURN 0;
  END IF;
  
  RETURN GREATEST(0, EXTRACT(DAY FROM (end_date - NOW()))::INTEGER);
END;
$$ LANGUAGE plpgsql;

-- Function to mark expired subscriptions
CREATE OR REPLACE FUNCTION mark_expired_subscriptions()
RETURNS INTEGER AS $$
DECLARE
  expired_count INTEGER := 0;
BEGIN
  UPDATE subscriptions
  SET is_expired = true,
      updated_at = NOW()
  WHERE is_active = true
    AND is_used = true
    AND activated_at IS NOT NULL
    AND activated_at + (duration_days || ' days')::INTERVAL < NOW();
  
  GET DIAGNOSTICS expired_count = ROW_COUNT;
  
  RETURN expired_count;
END;
$$ LANGUAGE plpgsql;
-- Migration: Create Doctors Table
-- Purpose: Store doctor information and profiles
-- Version: v2_P03_001
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_001_create_specialties_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Doctors Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create doctors table to store doctor information and profiles
CREATE TABLE IF NOT EXISTS doctors (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  specialty_id UUID REFERENCES specialties(id) ON DELETE SET NULL NOT NULL,

  -- Professional Information
  license_number VARCHAR(100) NOT NULL UNIQUE,
  license_expiry_date DATE,
  qualification VARCHAR(255),
  university VARCHAR(255),
  graduation_year INTEGER,
  experience_years INTEGER DEFAULT 0,
  
  -- Profile Information
  bio TEXT,
  bio_ar TEXT,
  consultation_fee DECIMAL(10, 2) DEFAULT 0.00,
  consultation_fee_currency VARCHAR(3) DEFAULT 'USD',
  
  -- Languages
  languages TEXT[] DEFAULT ARRAY[]::TEXT[],
  
  -- Availability
  is_available BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  is_accepting_new_patients BOOLEAN DEFAULT true,
  
  -- Working Hours
  working_hours JSONB,
  
  -- Ratings
  rating DECIMAL(3, 2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
  total_reviews INTEGER DEFAULT 0,
  
  -- Profile Media
  profile_image_url TEXT,
  
  -- Practice Information
  max_patients_per_day INTEGER DEFAULT 20,
  consultation_duration_minutes INTEGER DEFAULT 30,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_graduation_year CHECK (graduation_year IS NULL OR (graduation_year >= 1900 AND graduation_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 10)),
  CONSTRAINT valid_experience_years CHECK (experience_years >= 0),
  CONSTRAINT valid_consultation_fee CHECK (consultation_fee >= 0),
  CONSTRAINT valid_max_patients CHECK (max_patients_per_day > 0),
  CONSTRAINT valid_consultation_duration CHECK (consultation_duration_minutes > 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_doctors_user_id ON doctors(user_id);
CREATE INDEX idx_doctors_clinic_id ON doctors(clinic_id) WHERE is_available = true;
CREATE INDEX idx_doctors_specialty_id ON doctors(specialty_id) WHERE is_available = true;
CREATE INDEX idx_doctors_is_available ON doctors(is_available);
CREATE INDEX idx_doctors_is_verified ON doctors(is_verified);
CREATE INDEX idx_doctors_rating ON doctors(rating DESC) WHERE is_available = true;
CREATE INDEX idx_doctors_created_at ON doctors(created_at DESC);
CREATE INDEX idx_doctors_license_number ON doctors(license_number);
CREATE INDEX idx_doctors_is_accepting_new_patients ON doctors(is_accepting_new_patients) WHERE is_available = true;

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on doctors table
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

-- Policy: Verified doctors are viewable by everyone
CREATE POLICY "Verified doctors are viewable by everyone"
  ON doctors FOR SELECT
  USING (is_verified = true);

-- Policy: Doctors can view their own profile
CREATE POLICY "Doctors can view their own profile"
  ON doctors FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Doctors can update their own profile
CREATE POLICY "Doctors can update their own profile"
  ON doctors FOR UPDATE
  USING (user_id = auth.uid());

-- Policy: Super admins can manage all doctors
CREATE POLICY "Super admins can manage all doctors"
  ON doctors FOR ALL
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
CREATE OR REPLACE FUNCTION update_doctors_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER doctors_update_updated_at
  BEFORE UPDATE ON doctors
  FOR EACH ROW
  EXECUTE FUNCTION update_doctors_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE doctors IS 'Doctors information and profiles';
COMMENT ON COLUMN doctors.id IS 'Primary key (UUID)';
COMMENT ON COLUMN doctors.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN doctors.clinic_id IS 'Foreign key reference to clinics table';
COMMENT ON COLUMN doctors.specialty_id IS 'Foreign key reference to specialties table (UUID)';
COMMENT ON COLUMN doctors.license_number IS 'Medical license number';
COMMENT ON COLUMN doctors.consultation_fee IS 'Fee for consultation';
COMMENT ON COLUMN doctors.languages IS 'Array of languages spoken by the doctor';
COMMENT ON COLUMN doctors.working_hours IS 'JSON object containing working hours for each day';
COMMENT ON COLUMN doctors.max_patients_per_day IS 'Maximum number of patients the doctor can see per day';
COMMENT ON COLUMN doctors.consultation_duration_minutes IS 'Duration of consultation in minutes';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to get doctor's full name
CREATE OR REPLACE FUNCTION get_doctor_full_name(doctor_id UUID)
RETURNS VARCHAR(255) AS $$
DECLARE
  full_name VARCHAR(255);
BEGIN
  SELECT COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '')
  INTO full_name
  FROM users u
  JOIN doctors d ON u.id = d.user_id
  WHERE d.id = doctor_id;
  
  RETURN TRIM(full_name);
END;
$$ LANGUAGE plpgsql;

-- Function to check if doctor is available at a specific time
CREATE OR REPLACE FUNCTION is_doctor_available(doctor_id UUID, appointment_time TIMESTAMP WITH TIME ZONE)
RETURNS BOOLEAN AS $$
DECLARE
  working_hours JSONB;
  day_of_week TEXT;
  start_time TIME;
  end_time TIME;
  appointment_time_time TIME;
BEGIN
  -- Get working hours
  SELECT working_hours INTO working_hours
  FROM doctors
  WHERE id = doctor_id AND is_available = true;
  
  IF working_hours IS NULL THEN
    RETURN false;
  END IF;
  
  -- Get day of week (lowercase)
  day_of_week := LOWER(TO_CHAR(appointment_time, 'Day'));
  
  -- Get start and end times for that day
  start_time := (working_hours->day_of_week->>'start')::TIME;
  end_time := (working_hours->day_of_week->>'end')::TIME;
  
  IF start_time IS NULL OR end_time IS NULL THEN
    RETURN false;
  END IF;
  
  -- Get appointment time
  appointment_time_time := appointment_time::TIME;
  
  -- Check if within working hours
  RETURN appointment_time_time >= start_time AND appointment_time_time <= end_time;
END;
$$ LANGUAGE plpgsql;

-- Function to update doctor rating
CREATE OR REPLACE FUNCTION update_doctor_rating(doctor_id UUID, new_rating DECIMAL)
RETURNS VOID AS $$
DECLARE
  current_total_reviews INTEGER;
  current_avg_rating DECIMAL;
  new_total_reviews INTEGER;
  new_avg_rating DECIMAL;
BEGIN
  -- Get current stats
  SELECT total_reviews, rating INTO current_total_reviews, current_avg_rating
  FROM doctors
  WHERE id = doctor_id;
  
  -- Calculate new average
  new_total_reviews := current_total_reviews + 1;
  new_avg_rating := ((current_avg_rating * current_total_reviews) + new_rating) / new_total_reviews;
  
  -- Update doctor
  UPDATE doctors
  SET rating = ROUND(new_avg_rating::NUMERIC, 2),
      total_reviews = new_total_reviews
  WHERE id = doctor_id;
END;
$$ LANGUAGE plpgsql;
-- Migration: Create Patients Table
-- Purpose: Store patient-specific medical information
-- Version: v2_P03_002
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_002_create_clinics_table.sql, v2_P03_001_create_doctors_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Patients Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create patients table to store patient-specific medical information
CREATE TABLE IF NOT EXISTS patients (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  preferred_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  preferred_doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,

  -- Personal Information
  date_of_birth DATE,
  gender VARCHAR(20) CHECK (gender IN ('male', 'female', 'other')),
  blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
  marital_status VARCHAR(50),
  occupation VARCHAR(100),
  
  -- Emergency Contact
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(20),
  emergency_contact_relation VARCHAR(50),
  
  -- Insurance Information
  insurance_provider VARCHAR(255),
  insurance_number VARCHAR(100),
  insurance_expiry_date DATE,
  
  -- Medical History
  medical_history TEXT[],
  allergies TEXT[],
  chronic_conditions TEXT[],
  current_medications TEXT[],
  
  -- Physical Measurements
  height DECIMAL(5, 2),  -- in cm
  weight DECIMAL(5, 2),  -- in kg
  bmi DECIMAL(4, 1),
  
  -- Lifestyle Information
  smoking_status VARCHAR(20) CHECK (smoking_status IN ('never', 'former', 'current', 'unknown')),
  alcohol_consumption VARCHAR(50),
  physical_activity VARCHAR(50),
  dietary_restrictions TEXT[],
  
  -- Profile Media
  profile_image_url TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_height CHECK (height IS NULL OR (height > 0 AND height < 300)),
  CONSTRAINT valid_weight CHECK (weight IS NULL OR (weight > 0 AND weight < 500)),
  CONSTRAINT valid_bmi CHECK (bmi IS NULL OR (bmi > 0 AND bmi < 100))
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_patients_user_id ON patients(user_id);
CREATE INDEX idx_patients_preferred_clinic_id ON patients(preferred_clinic_id);
CREATE INDEX idx_patients_preferred_doctor_id ON patients(preferred_doctor_id);
CREATE INDEX idx_patients_is_active ON patients(is_active);
CREATE INDEX idx_patients_date_of_birth ON patients(date_of_birth);
CREATE INDEX idx_patients_blood_type ON patients(blood_type);
CREATE INDEX idx_patients_gender ON patients(gender);
CREATE INDEX idx_patients_created_at ON patients(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on patients table
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own profile
CREATE POLICY "Patients can view their own profile"
  ON patients FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Patients can update their own profile
CREATE POLICY "Patients can update their own profile"
  ON patients FOR UPDATE
  USING (user_id = auth.uid());

-- Policy: Super admins can manage all patients
CREATE POLICY "Super admins can manage all patients"
  ON patients FOR ALL
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
CREATE OR REPLACE FUNCTION update_patients_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER patients_update_updated_at
  BEFORE UPDATE ON patients
  FOR EACH ROW
  EXECUTE FUNCTION update_patients_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- BMI Calculation Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to calculate BMI
CREATE OR REPLACE FUNCTION calculate_patient_bmi()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.height IS NOT NULL AND NEW.weight IS NOT NULL AND NEW.height > 0 THEN
    NEW.bmi := ROUND((NEW.weight / POWER(NEW.height / 100, 2))::NUMERIC, 1);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for BMI calculation
CREATE TRIGGER calculate_patient_bmi
  BEFORE INSERT OR UPDATE OF height, weight ON patients
  FOR EACH ROW
  EXECUTE FUNCTION calculate_patient_bmi();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE patients IS 'Patient-specific medical information';
COMMENT ON COLUMN patients.id IS 'Primary key (UUID)';
COMMENT ON COLUMN patients.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN patients.preferred_clinic_id IS 'Preferred clinic ID';
COMMENT ON COLUMN patients.preferred_doctor_id IS 'Preferred doctor ID';
COMMENT ON COLUMN patients.blood_type IS 'Patient blood type (A+, A-, B+, B-, AB+, AB-, O+, O-)';
COMMENT ON COLUMN patients.medical_history IS 'Array of past medical conditions';
COMMENT ON COLUMN patients.allergies IS 'Array of known allergies';
COMMENT ON COLUMN patients.bmi IS 'Body Mass Index calculated from height and weight';
COMMENT ON COLUMN patients.smoking_status IS 'Patient smoking habits (never, former, current)';

-- ══════════════════════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════════════════════

-- Function to get patient's age
CREATE OR REPLACE FUNCTION get_patient_age(patient_id UUID)
RETURNS INTEGER AS $$
DECLARE
  date_of_birth DATE;
BEGIN
  SELECT date_of_birth INTO date_of_birth
  FROM patients
  WHERE id = patient_id;
  
  IF date_of_birth IS NULL THEN
    RETURN NULL;
  END IF;
  
  RETURN EXTRACT(YEAR FROM AGE(date_of_birth))::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- Function to get patient's full name
CREATE OR REPLACE FUNCTION get_patient_full_name(patient_id UUID)
RETURNS VARCHAR(255) AS $$
DECLARE
  full_name VARCHAR(255);
BEGIN
  SELECT COALESCE(u.first_name, '') || ' ' || COALESCE(u.last_name, '')
  INTO full_name
  FROM users u
  JOIN patients p ON u.id = p.user_id
  WHERE p.id = patient_id;
  
  RETURN TRIM(full_name);
END;
$$ LANGUAGE plpgsql;

-- Function to check if patient has allergies
CREATE OR REPLACE FUNCTION patient_has_allergies(patient_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  allergy_count INTEGER;
BEGIN
  SELECT cardinality(allergies) INTO allergy_count
  FROM patients
  WHERE id = patient_id;
  
  RETURN allergy_count > 0;
END;
$$ LANGUAGE plpgsql;
-- Migration: Create Employees Table
-- Purpose: Store employee information and employment details
-- Version: v2_P03_003
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql, v2_P02_002_create_clinics_table.sql

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
-- Migration: Create Clinic Staff Table
-- Purpose: Junction table linking clinics to staff members

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
-- DEFERRED RLS POLICIES FOR DOCTORS TABLE
-- (These depend on clinic_staff existing)
-- ═════════════════════════════════════════════

-- Policy: Clinic staff can view employees in their clinic
CREATE POLICY "Clinic staff can view clinic employees"
  ON employees FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view doctors in their clinic
CREATE POLICY "Clinic staff can view clinic doctors"
  ON doctors FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic admins can update doctors in their clinic
CREATE POLICY "Clinic admins can update clinic doctors"
  ON doctors FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE clinic_id = doctors.clinic_id
      AND user_id = auth.uid()
      AND role IN ('admin', 'manager')
    )
  );

-- Policy: Clinic staff can view patients in their clinic
CREATE POLICY "Clinic staff can view clinic patients"
  ON patients FOR SELECT
  USING (
    preferred_clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

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
-- Migration: Create Appointments Table
-- Purpose: Store appointment information
-- Version: v2_P04_001
-- Created: 2026-03-04
-- Dependencies: v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Appointments Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create appointments table to store appointment information
CREATE TABLE IF NOT EXISTS appointments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  prescription_id UUID REFERENCES prescriptions(id) ON DELETE SET NULL,

  -- Appointment Details
  appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
  appointment_end_time TIMESTAMP WITH TIME ZONE,
  status appointment_status DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'no_show', 'cancelled', 'rescheduled')),
  appointment_type VARCHAR(50) DEFAULT 'consultation',
  
  -- Medical Information
  reason_for_visit TEXT,
  symptoms TEXT[],
  notes TEXT,
  diagnosis TEXT,
  
  -- Follow-up
  follow_up_required BOOLEAN DEFAULT false,
  follow_up_date TIMESTAMP WITH TIME ZONE,
  
  -- Video Call
  video_call_enabled BOOLEAN DEFAULT false,
  video_call_room_id VARCHAR(255),
  video_call_started_at TIMESTAMP WITH TIME ZONE,
  video_call_ended_at TIMESTAMP WITH TIME ZONE,
  video_call_duration_seconds INTEGER,
  
  -- Reminders
  reminder_sent BOOLEAN DEFAULT false,
  reminder_sent_at TIMESTAMP WITH TIME ZONE,
  
  -- Cancellation
  cancellation_reason TEXT,
  cancelled_by UUID REFERENCES users(id) ON DELETE SET NULL,
  cancelled_at TIMESTAMP WITH TIME ZONE,
  
  -- No Show
  no_show_reason TEXT,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_appointment_dates CHECK (
    appointment_end_time IS NULL OR 
    appointment_end_time > appointment_date
  ),
  CONSTRAINT valid_video_call_duration CHECK (
    video_call_duration_seconds IS NULL OR 
    video_call_duration_seconds >= 0
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_clinic_id ON appointments(clinic_id);
CREATE INDEX idx_appointments_appointment_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_appointments_appointment_type ON appointments(appointment_type);
CREATE INDEX idx_appointments_prescription_id ON appointments(prescription_id);
CREATE INDEX idx_appointments_created_at ON appointments(created_at DESC);

-- Create composite index for doctor's schedule
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointments_patient_date ON appointments(patient_id, appointment_date);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on appointments table
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own appointments
CREATE POLICY "Patients can view their own appointments"
  ON appointments FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view their appointments
CREATE POLICY "Doctors can view their appointments"
  ON appointments FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic appointments
CREATE POLICY "Clinic staff can view clinic appointments"
  ON appointments FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Patients can create appointments
CREATE POLICY "Patients can create appointments"
  ON appointments FOR INSERT
  WITH CHECK (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can update their appointments
CREATE POLICY "Doctors can update their appointments"
  ON appointments FOR UPDATE
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Patients can cancel their own appointments
CREATE POLICY "Patients can cancel their appointments"
  ON appointments FOR UPDATE
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
    AND status IN ('pending', 'confirmed')
    AND NEW.status = 'cancelled'
  );

-- Policy: Super admins can manage all appointments
CREATE POLICY "Super admins can manage all appointments"
  ON appointments FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- DEFERRED RLS POLICIES FOR PATIENTS TABLE
-- (These depend on appointments existing)
CREATE POLICY "Doctors can view their patients"
  ON patients FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM appointments
      WHERE appointments.patient_id = patients.id
      AND appointments.doctor_id IN (
        SELECT id FROM doctors WHERE user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Doctors can update patient medical info"
  ON patients FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM appointments
      WHERE appointments.patient_id = patients.id
      AND appointments.doctor_id IN (
        SELECT id FROM doctors WHERE user_id = auth.uid()
      )
      AND appointments.status = 'completed'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_appointments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER appointments_update_updated_at
  BEFORE UPDATE ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION update_appointments_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Overlapping Appointments Prevention Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to prevent overlapping appointments
CREATE OR REPLACE FUNCTION prevent_overlapping_appointments()
RETURNS TRIGGER AS $$
DECLARE
  overlapping_count INTEGER;
BEGIN
  -- Check for overlapping appointments for the same doctor
  SELECT COUNT(*) INTO overlapping_count
  FROM appointments
  WHERE doctor_id = NEW.doctor_id
  AND id != COALESCE(NEW.id, gen_random_uuid())
  AND status NOT IN ('cancelled', 'no_show')
  AND (
    (NEW.appointment_date < COALESCE(appointment_end_time, NEW.appointment_date + INTERVAL '1 hour'))
    AND (COALESCE(NEW.appointment_end_time, NEW.appointment_date + INTERVAL '1 hour') > appointment_date)
  );

  IF overlapping_count > 0 THEN
    RAISE EXCEPTION 'Doctor has an overlapping appointment';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for preventing overlapping appointments
CREATE TRIGGER prevent_appointment_overlap
  BEFORE INSERT OR UPDATE OF appointment_date, appointment_end_time, doctor_id ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION prevent_overlapping_appointments();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE appointments IS 'Medical appointments information';
COMMENT ON COLUMN appointments.status IS 'Appointment status: pending, confirmed, in_progress, completed, cancelled, no_show, rescheduled';
COMMENT ON COLUMN appointments.appointment_type IS 'Type of appointment: consultation, follow-up, emergency, video_call, etc.';
COMMENT ON COLUMN appointments.video_call_enabled IS 'Whether video call is enabled for this appointment';
COMMENT ON COLUMN appointments.video_call_room_id IS 'Room ID for video call';
COMMENT ON COLUMN appointments.follow_up_required IS 'Whether a follow-up appointment is needed';
-- Migration: Create Prescriptions Table
-- Purpose: Store prescription information
-- Version: v2_P04_002
-- Created: 2026-03-04
-- Dependencies: v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P04_001_create_appointments_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Prescriptions Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create prescriptions table to store prescription information
CREATE TABLE IF NOT EXISTS prescriptions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
  appointment_id UUID,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- Prescription Information
  prescription_number VARCHAR(50) NOT NULL UNIQUE,
  
  -- Medical Information
  diagnosis TEXT,
  symptoms TEXT[],
  notes TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_prescriptions_patient_id ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_doctor_id ON prescriptions(doctor_id);
CREATE INDEX idx_prescriptions_appointment_id ON prescriptions(appointment_id);
CREATE INDEX idx_prescriptions_clinic_id ON prescriptions(clinic_id);
CREATE INDEX idx_prescriptions_prescription_number ON prescriptions(prescription_number);
CREATE INDEX idx_prescriptions_is_active ON prescriptions(is_active);
CREATE INDEX idx_prescriptions_created_at ON prescriptions(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on prescriptions table
ALTER TABLE prescriptions ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own prescriptions
CREATE POLICY "Patients can view their own prescriptions"
  ON prescriptions FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view prescriptions they created
CREATE POLICY "Doctors can view their prescriptions"
  ON prescriptions FOR SELECT
  USING (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Clinic staff can view clinic prescriptions
CREATE POLICY "Clinic staff can view clinic prescriptions"
  ON prescriptions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can create prescriptions
CREATE POLICY "Doctors can create prescriptions"
  ON prescriptions FOR INSERT
  WITH CHECK (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Doctors can update their prescriptions
CREATE POLICY "Doctors can update their prescriptions"
  ON prescriptions FOR UPDATE
  USING (doctor_id IN (SELECT id FROM doctors WHERE user_id = auth.uid()));

-- Policy: Super admins can manage all prescriptions
CREATE POLICY "Super admins can manage all prescriptions"
  ON prescriptions FOR ALL
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
CREATE OR REPLACE FUNCTION update_prescriptions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER prescriptions_update_updated_at
  BEFORE UPDATE ON prescriptions
  FOR EACH ROW
  EXECUTE FUNCTION update_prescriptions_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE prescriptions IS 'Medical prescriptions information';
COMMENT ON COLUMN prescriptions.prescription_number IS 'Unique prescription identification number';

-- ══════════════════════════════════════════════════════════════════════════════
-- ADD DEFERRED FK CONSTRAINT FOR appointment_id
-- (Defined here, will be added after appointments table is created)
-- ══════════════════════════════════════════════════════════════════════════════

ALTER TABLE prescriptions
ADD CONSTRAINT fk_prescriptions_appointment_id
FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Prescription Items Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create prescription_items table for individual medications
CREATE TABLE IF NOT EXISTS prescription_items (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,

  -- Medication Information
  medication_name VARCHAR(255) NOT NULL,
  medication_name_ar VARCHAR(255),
  
  -- Dosage Information
  dosage VARCHAR(100) NOT NULL,
  frequency VARCHAR(100) NOT NULL,
  duration VARCHAR(100) NOT NULL,
  route VARCHAR(50) DEFAULT 'oral' CHECK (route IN ('oral', 'injection', 'topical', 'inhalation', 'other')),
  
  -- Instructions
  instructions TEXT,
  instructions_ar TEXT,
  
  -- Quantity and Refills
  quantity INTEGER,
  refills_allowed INTEGER DEFAULT 0,
  refills_remaining INTEGER DEFAULT 0,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_quantity CHECK (quantity IS NULL OR quantity > 0),
  CONSTRAINT valid_refills CHECK (refills_remaining >= 0 AND refills_remaining <= refills_allowed)
);

-- Create indexes for prescription_items
CREATE INDEX idx_prescription_items_prescription_id ON prescription_items(prescription_id);
CREATE INDEX idx_prescription_items_medication_name ON prescription_items(medication_name);
CREATE INDEX idx_prescription_items_is_active ON prescription_items(is_active);

-- Add RLS policies for prescription_items
ALTER TABLE prescription_items ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view prescription items through prescriptions
CREATE POLICY "Users can view prescription items via prescriptions"
  ON prescription_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM prescriptions p
      JOIN patients pat ON p.patient_id = pat.id
      WHERE p.id = prescription_items.prescription_id
      AND pat.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM prescriptions p
      JOIN doctors d ON p.doctor_id = d.id
      WHERE p.id = prescription_items.prescription_id
      AND d.user_id = auth.uid()
    )
  );

-- Create trigger for updated_at
CREATE TRIGGER update_prescription_items_updated_at
  BEFORE UPDATE ON prescription_items
  FOR EACH ROW
  EXECUTE FUNCTION update_prescription_items_updated_at();

-- Add comments
COMMENT ON TABLE prescription_items IS 'Individual medications in a prescription';
COMMENT ON COLUMN prescription_items.dosage IS 'Medication dosage (e.g., 10mg, 5ml)';
COMMENT ON COLUMN prescription_items.frequency IS 'How often to take the medication (e.g., twice daily, every 8 hours)';
COMMENT ON COLUMN prescription_items.duration IS 'How long to take the medication (e.g., 7 days, 2 weeks)';
COMMENT ON COLUMN prescription_items.route IS 'Administration route: oral, injection, topical, inhalation, other';
COMMENT ON COLUMN prescription_items.refills_allowed IS 'Number of refills allowed for this medication';
COMMENT ON COLUMN prescription_items.refills_remaining IS 'Number of refills remaining';
-- Migration: Create Lab Results Table
-- Purpose: Store laboratory test results
-- Version: v2_P04_003
-- Created: 2026-03-04
-- Dependencies: v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P04_001_create_appointments_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Lab Results Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create lab_results table to store laboratory test results
CREATE TABLE IF NOT EXISTS lab_results (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,

  -- Test Information
  test_name VARCHAR(255) NOT NULL,
  test_name_ar VARCHAR(255),
  test_category VARCHAR(100),
  test_date DATE NOT NULL,
  result_date DATE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
  
  -- Results
  results JSONB,
  normal_range TEXT,
  interpretation TEXT,
  interpretation_ar TEXT,
  notes TEXT,
  
  -- Performed By
  performed_by VARCHAR(255),
  lab_technician_id UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Flags
  is_abnormal BOOLEAN DEFAULT false,
  requires_follow_up BOOLEAN DEFAULT false,
  
  -- Report
  report_url TEXT,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_lab_results_patient_id ON lab_results(patient_id);
CREATE INDEX idx_lab_results_doctor_id ON lab_results(doctor_id);
CREATE INDEX idx_lab_results_clinic_id ON lab_results(clinic_id);
CREATE INDEX idx_lab_results_appointment_id ON lab_results(appointment_id);
CREATE INDEX idx_lab_results_test_name ON lab_results(test_name);
CREATE INDEX idx_lab_results_test_category ON lab_results(test_category);
CREATE INDEX idx_lab_results_test_date ON lab_results(test_date);
CREATE INDEX idx_lab_results_status ON lab_results(status);
CREATE INDEX idx_lab_results_is_abnormal ON lab_results(is_abnormal);
CREATE INDEX idx_lab_results_created_at ON lab_results(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on lab_results table
ALTER TABLE lab_results ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own lab results
CREATE POLICY "Patients can view their own lab results"
  ON lab_results FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view lab results for their patients
CREATE POLICY "Doctors can view their patients lab results"
  ON lab_results FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic lab results
CREATE POLICY "Clinic staff can view clinic lab results"
  ON lab_results FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Lab technicians can create and update lab results
CREATE POLICY "Lab technicians can manage lab results"
  ON lab_results FOR ALL
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('lab_technician', 'doctor', 'admin', 'manager')
    )
  );

-- Policy: Super admins can manage all lab results
CREATE POLICY "Super admins can manage all lab results"
  ON lab_results FOR ALL
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
CREATE OR REPLACE FUNCTION update_lab_results_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER update_lab_results_updated_at
  BEFORE UPDATE ON lab_results
  FOR EACH ROW
  EXECUTE FUNCTION update_lab_results_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE lab_results IS 'Laboratory test results';
COMMENT ON COLUMN lab_results.status IS 'Test status: pending, in_progress, completed, cancelled';
COMMENT ON COLUMN lab_results.results IS 'JSON object containing test results and values';
COMMENT ON COLUMN lab_results.normal_range IS 'Normal reference range for the test';
COMMENT ON COLUMN lab_results.interpretation IS 'Clinical interpretation of the results';
COMMENT ON COLUMN lab_results.is_abnormal IS 'Whether results are outside normal range';
COMMENT ON COLUMN lab_results.requires_follow_up IS 'Whether follow-up testing is required';

-- ══════════════════════════════════════════════════════════════════════════════
-- Vital Signs Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create vital_signs table for patient vital signs
CREATE TABLE IF NOT EXISTS vital_signs (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,

  -- Recording Information
  recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  recorded_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Vital Signs Measurements
  temperature DECIMAL(4, 1),  -- in Celsius
  temperature_unit VARCHAR(10) DEFAULT 'C',
  heart_rate INTEGER,  -- beats per minute
  blood_pressure_systolic INTEGER,  -- mmHg
  blood_pressure_diastolic INTEGER,  -- mmHg
  respiratory_rate INTEGER,  -- breaths per minute
  oxygen_saturation DECIMAL(3, 1),  -- percentage
  weight DECIMAL(5, 2),  -- in kg
  weight_unit VARCHAR(10) DEFAULT 'kg',
  height DECIMAL(5, 2),  -- in cm
  height_unit VARCHAR(10) DEFAULT 'cm',
  bmi DECIMAL(4, 1),
  blood_glucose DECIMAL(5, 1),  -- mg/dL
  blood_glucose_unit VARCHAR(10) DEFAULT 'mg/dL',
  
  -- Notes
  notes TEXT,
  is_abnormal BOOLEAN DEFAULT false,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_temperature CHECK (temperature IS NULL OR (temperature >= 30 AND temperature <= 45)),
  CONSTRAINT valid_heart_rate CHECK (heart_rate IS NULL OR (heart_rate >= 30 AND heart_rate <= 220)),
  CONSTRAINT valid_respiratory_rate CHECK (respiratory_rate IS NULL OR (respiratory_rate >= 5 AND respiratory_rate <= 60)),
  CONSTRAINT valid_oxygen_saturation CHECK (oxygen_saturation IS NULL OR (oxygen_saturation >= 70 AND oxygen_saturation <= 100)),
  CONSTRAINT valid_bmi CHECK (bmi IS NULL OR (bmi >= 10 AND bmi <= 60))
);

-- Create indexes for vital_signs
CREATE INDEX idx_vital_signs_patient_id ON vital_signs(patient_id);
CREATE INDEX idx_vital_signs_doctor_id ON vital_signs(doctor_id);
CREATE INDEX idx_vital_signs_clinic_id ON vital_signs(clinic_id);
CREATE INDEX idx_vital_signs_appointment_id ON vital_signs(appointment_id);
CREATE INDEX idx_vital_signs_recorded_at ON vital_signs(recorded_at);
CREATE INDEX idx_vital_signs_is_abnormal ON vital_signs(is_abnormal);

-- Add RLS policies for vital_signs
ALTER TABLE vital_signs ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own vital signs
CREATE POLICY "Patients can view their own vital signs"
  ON vital_signs FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view vital signs for their patients
CREATE POLICY "Doctors can view their patients vital signs"
  ON vital_signs FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic vital signs
CREATE POLICY "Clinic staff can view clinic vital signs"
  ON vital_signs FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Medical staff can create vital signs
CREATE POLICY "Medical staff can create vital signs"
  ON vital_signs FOR INSERT
  WITH CHECK (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('doctor', 'nurse', 'admin', 'manager')
    )
  );

-- Create trigger for updated_at
CREATE TRIGGER update_vital_signs_updated_at
  BEFORE UPDATE ON vital_signs
  FOR EACH ROW
  EXECUTE FUNCTION update_vital_signs_updated_at();

-- Add comments
COMMENT ON TABLE vital_signs IS 'Patient vital signs measurements';
COMMENT ON COLUMN vital_signs.temperature IS 'Body temperature in Celsius';
COMMENT ON COLUMN vital_signs.heart_rate IS 'Heart rate in beats per minute';
COMMENT ON COLUMN vital_signs.blood_pressure_systolic IS 'Systolic blood pressure in mmHg';
COMMENT ON COLUMN vital_signs.blood_pressure_diastolic IS 'Diastolic blood pressure in mmHg';
COMMENT ON COLUMN vital_signs.respiratory_rate IS 'Respiratory rate in breaths per minute';
COMMENT ON COLUMN vital_signs.oxygen_saturation IS 'Oxygen saturation percentage';
COMMENT ON COLUMN vital_signs.blood_glucose IS 'Blood glucose level in mg/dL';
-- Migration: Create Video Sessions Table
-- Purpose: Store video call session information
-- Version: v2_P04_004
-- Created: 2026-03-04
-- Dependencies: v2_P04_001_create_appointments_table.sql, v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Video Sessions Table
-- ════════════════════════════════════════════════════════════════════════════

-- Create video_sessions table to store video call session information
CREATE TABLE IF NOT EXISTS video_sessions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- WebRTC Information\n  channel_name VARCHAR(255) NOT NULL,
  room_id VARCHAR(255) UNIQUE NOT NULL,
  token TEXT,

  -- Session Status
  status video_session_status DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled', 'failed', 'no_show')),
  
  -- Scheduled Times
  scheduled_start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  scheduled_end_time TIMESTAMP WITH TIME ZONE NOT NULL,
  
  -- Actual Times
  actual_start_time TIMESTAMP WITH TIME ZONE,
  actual_end_time TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,
  
  -- Session Information
  initiator_id UUID REFERENCES users(id) ON DELETE SET NULL,
  termination_reason TEXT,
  
  -- Quality Assessment
  quality_rating INTEGER CHECK (quality_rating BETWEEN 1 AND 5),
  quality_feedback TEXT,
  
  -- Recording
  recording_enabled BOOLEAN DEFAULT false,
  recording_url TEXT,
  screenshot_count INTEGER DEFAULT 0,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_scheduled_times CHECK (
    scheduled_end_time > scheduled_start_time
  ),
  CONSTRAINT valid_duration CHECK (
    duration_seconds IS NULL OR duration_seconds >= 0
  )
);

-- ════════════════════════════════════════════════════════════════════
-- Indexes
-- ════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_video_sessions_appointment_id ON video_sessions(appointment_id);
CREATE INDEX idx_video_sessions_patient_id ON video_sessions(patient_id);
CREATE INDEX idx_video_sessions_doctor_id ON video_sessions(doctor_id);
CREATE INDEX idx_video_sessions_clinic_id ON video_sessions(clinic_id);
CREATE INDEX idx_video_sessions_channel_name ON video_sessions(channel_name);
CREATE INDEX idx_video_sessions_room_id ON video_sessions(room_id);
CREATE INDEX idx_video_sessions_status ON video_sessions(status);
CREATE INDEX idx_video_sessions_scheduled_start_time ON video_sessions(scheduled_start_time);
CREATE INDEX idx_video_sessions_created_at ON video_sessions(created_at DESC);

-- ══════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════

-- Enable RLS on video_sessions table
ALTER TABLE video_sessions ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own video sessions
CREATE POLICY "Patients can view their own video sessions"
  ON video_sessions FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view their video sessions
CREATE POLICY "Doctors can view their video sessions"
  ON video_sessions FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic video sessions
CREATE POLICY "Clinic staff can view clinic video sessions"
  ON video_sessions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Authorized users can create video sessions
CREATE POLICY "Authorized users can create video sessions"
  ON video_sessions FOR INSERT
  WITH CHECK (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
    OR doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Participants can update video sessions
CREATE POLICY "Participants can update video sessions"
  ON video_sessions FOR UPDATE
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
    OR doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Super admins can manage all video sessions
CREATE POLICY "Super admins can manage all video sessions"
  ON video_sessions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════
-- Triggers
-- ════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_video_sessions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER update_video_sessions_updated_at
  BEFORE UPDATE ON video_sessions
  FOR EACH ROW
  EXECUTE FUNCTION update_video_sessions_updated_at();

-- ════════════════════════════════════════════════════════════════
-- Video Session Duration Calculation Trigger
-- ══════════════════════════════════════════════════════════════

-- Create function to calculate duration when session ends
CREATE OR REPLACE FUNCTION calculate_video_session_duration()
RETURNS TRIGGER AS $$
BEGIN
  -- Calculate duration when session status changes to completed
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    IF NEW.actual_start_time IS NOT NULL AND NEW.actual_end_time IS NOT NULL THEN
      NEW.duration_seconds := EXTRACT(EPOCH FROM (NEW.actual_end_time - NEW.actual_start_time))::INTEGER;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for calculating duration
CREATE TRIGGER calculate_video_duration_on_completion
  BEFORE UPDATE OF status, actual_start_time, actual_end_time ON video_sessions
  FOR EACH ROW
  EXECUTE FUNCTION calculate_video_session_duration();

-- ══════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════

COMMENT ON TABLE video_sessions IS 'Video call session information';
COMMENT ON COLUMN video_sessions.channel_name IS 'WebRTC channel name for the video call';
COMMENT ON COLUMN video_sessions.room_id IS 'Unique room identifier for the video call';
COMMENT ON COLUMN video_sessions.status IS 'Session status: scheduled, in_progress, completed, cancelled, failed, no_show';
COMMENT ON COLUMN video_sessions.duration_seconds IS 'Actual duration of the video call in seconds';
COMMENT ON COLUMN video_sessions.quality_rating IS 'User rating of video call quality (1-5)';

-- Migration: Create Invoices Table
-- Purpose: Store invoice information for services rendered
-- Version: v2_P05_001
-- Created: 2026-03-04
-- Dependencies: v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P04_001_create_appointments_table.sql, v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Invoices Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create invoices table to store invoice information
CREATE TABLE IF NOT EXISTS invoices (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Invoice Information
  invoice_number VARCHAR(50) NOT NULL UNIQUE,
  
  -- Foreign Keys
  patient_id UUID REFERENCES patients(id) ON DELETE SET NULL,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  
  -- Invoice Dates
  invoice_date DATE NOT NULL,
  due_date DATE,
  
  -- Status
  status invoice_status DEFAULT 'pending' CHECK (status IN ('draft', 'issued', 'pending', 'paid', 'overdue', 'cancelled', 'refunded')),
  
  -- Amounts
  subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  currency VARCHAR(3) DEFAULT 'USD',
  
  -- Payment Information
  payment_method VARCHAR(50),
  payment_date TIMESTAMP WITH TIME ZONE,
  payment_reference VARCHAR(255),
  
  -- Notes
  notes TEXT,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_amounts CHECK (
    subtotal >= 0 AND
    tax_amount >= 0 AND
    discount_amount >= 0 AND
    total_amount >= 0
  ),
  CONSTRAINT valid_due_date CHECK (
    due_date IS NULL OR due_date >= invoice_date
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_invoices_patient_id ON invoices(patient_id);
CREATE INDEX idx_invoices_doctor_id ON invoices(doctor_id);
CREATE INDEX idx_invoices_clinic_id ON invoices(clinic_id);
CREATE INDEX idx_invoices_appointment_id ON invoices(appointment_id);
CREATE INDEX idx_invoices_invoice_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_invoice_date ON invoices(invoice_date);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);
CREATE INDEX idx_invoices_created_at ON invoices(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on invoices table
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own invoices
CREATE POLICY "Patients can view their own invoices"
  ON invoices FOR SELECT
  USING (
    patient_id IN (
      SELECT id FROM patients WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors can view invoices for their appointments
CREATE POLICY "Doctors can view their appointment invoices"
  ON invoices FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic invoices
CREATE POLICY "Clinic staff can view clinic invoices"
  ON invoices FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can create invoices
CREATE POLICY "Clinic staff can create invoices"
  ON invoices FOR INSERT
  WITH CHECK (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can update invoices
CREATE POLICY "Clinic staff can update invoices"
  ON invoices FOR UPDATE
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Super admins can manage all invoices
CREATE POLICY "Super admins can manage all invoices"
  ON invoices FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ════════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_invoices_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER update_invoices_updated_at
  BEFORE UPDATE ON invoices
  FOR EACH ROW
  EXECUTE FUNCTION update_invoices_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE invoices IS 'Invoice information for services rendered';
COMMENT ON COLUMN invoices.status IS 'Invoice status: draft, issued, pending, paid, overdue, cancelled, refunded';
COMMENT ON COLUMN invoices.payment_method IS 'Method of payment: cash, card, insurance, etc.';

-- ══════════════════════════════════════════════════════════════════════════════
-- Invoice Items Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create invoice_items table for individual line items
CREATE TABLE IF NOT EXISTS invoice_items (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,

  -- Item Information
  item_type VARCHAR(50) CHECK (item_type IN ('service', 'medication', 'lab_test', 'procedure', 'other')),
  item_name VARCHAR(255) NOT NULL,
  item_name_ar VARCHAR(255),
  description TEXT,
  
  -- Quantity and Price
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  total_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_quantity CHECK (quantity > 0),
  CONSTRAINT valid_prices CHECK (
    unit_price >= 0 AND
    discount_amount >= 0 AND
    total_price >= 0
  )
);

-- Create indexes for invoice_items
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX idx_invoice_items_item_type ON invoice_items(item_type);

-- Add RLS policies for invoice_items
ALTER TABLE invoice_items ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view invoice items through invoices
CREATE POLICY "Users can view invoice items via invoices"
  ON invoice_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM invoices i
      JOIN patients pat ON i.patient_id = pat.id
      WHERE i.id = invoice_items.invoice_id
      AND pat.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM invoices i
      JOIN clinic_staff cs ON i.clinic_id = cs.clinic_id
      WHERE i.id = invoice_items.invoice_id
      AND cs.user_id = auth.uid()
    )
  );

-- Add comments
COMMENT ON TABLE invoice_items IS 'Individual line items in an invoice';
COMMENT ON COLUMN invoice_items.item_type IS 'Type of item: service, medication, lab_test, procedure, other';
COMMENT ON COLUMN invoice_items.quantity IS 'Quantity of items';
COMMENT ON COLUMN invoice_items.unit_price IS 'Price per unit';
COMMENT ON COLUMN invoice_items.discount_amount IS 'Discount amount';
COMMENT ON COLUMN invoice_items.total_price IS 'Total price (quantity × unit_price - discount)';
-- Migration: Create Inventory Table
-- Purpose: Store clinic inventory and stock management
-- Version: v2_P05_002
-- Created: 2026-03-04
-- Dependencies: v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create inventory table to store clinic inventory and stock management
CREATE TABLE IF NOT EXISTS inventory (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,

  -- Item Information
  item_code VARCHAR(50) NOT NULL UNIQUE,
  item_name VARCHAR(255) NOT NULL,
  item_name_ar VARCHAR(255),
  category VARCHAR(100),
  description TEXT,
  
  -- Unit Information
  unit VARCHAR(50) DEFAULT 'piece',
  
  -- Stock Information
  current_stock INTEGER NOT NULL DEFAULT 0,
  minimum_stock INTEGER NOT NULL DEFAULT 10,
  maximum_stock INTEGER NOT NULL DEFAULT 1000,
  reorder_quantity INTEGER NOT NULL DEFAULT 50,
  
  -- Pricing
  unit_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  selling_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  currency VARCHAR(3) DEFAULT 'USD',
  
  -- Supplier Information
  supplier VARCHAR(255),
  supplier_contact VARCHAR(255),
  
  -- Expiry Information (for perishable items)
  expiry_date DATE,
  batch_number VARCHAR(100),
  
  -- Storage
  storage_location VARCHAR(100),
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_stock CHECK (
    current_stock >= 0 AND
    minimum_stock >= 0 AND
    maximum_stock >= minimum_stock AND
    reorder_quantity > 0
  ),
  CONSTRAINT valid_prices CHECK (
    unit_cost >= 0 AND
    selling_price >= 0
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_inventory_clinic_id ON inventory(clinic_id);
CREATE INDEX idx_inventory_item_code ON inventory(item_code);
CREATE INDEX idx_inventory_category ON inventory(category);
CREATE INDEX idx_inventory_is_active ON inventory(is_active);
CREATE INDEX idx_inventory_expiry_date ON inventory(expiry_date);
CREATE INDEX idx_inventory_created_at ON inventory(created_at DESC);

-- ════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ════════════════════════════════════════════════════════════════════════════

-- Enable RLS on inventory table
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;

-- Policy: Clinic staff can view inventory in their clinic
CREATE POLICY "Clinic staff can view clinic inventory"
  ON inventory FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can create inventory items
CREATE POLICY "Clinic staff can create inventory items"
  ON inventory FOR INSERT
  WITH CHECK (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can update inventory items
CREATE POLICY "Clinic staff can update inventory items"
  ON inventory FOR UPDATE
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Super admins can manage all inventory
CREATE POLICY "Super admins can manage all inventory"
  ON inventory FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_inventory_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER update_inventory_updated_at
  BEFORE UPDATE ON inventory
  FOR EACH ROW
  EXECUTE FUNCTION update_inventory_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE inventory IS 'Clinic inventory and stock management';
COMMENT ON COLUMN inventory.item_code IS 'Unique item identification code';
COMMENT ON COLUMN inventory.current_stock IS 'Current quantity in stock';
COMMENT ON COLUMN inventory.minimum_stock IS 'Minimum stock level before reordering';
COMMENT ON COLUMN inventory.maximum_stock IS 'Maximum stock capacity';
COMMENT ON COLUMN inventory.reorder_quantity IS 'Quantity to reorder when stock reaches minimum';
COMMENT ON COLUMN inventory.expiry_date IS 'Expiry date for perishable items';

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory Transactions Table
-- ════════════════════════════════════════════════════════════════════════════

-- Create inventory_transactions table for tracking stock movements
CREATE TABLE IF NOT EXISTS inventory_transactions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  inventory_id UUID NOT NULL REFERENCES inventory(id) ON DELETE CASCADE,

  -- Transaction Information
  transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'return', 'adjustment', 'transfer', 'expiry', 'damage', 'restock')),
  
  -- Quantity
  quantity INTEGER NOT NULL,
  unit_cost DECIMAL(10, 2),
  total_cost DECIMAL(10, 2),
  
  -- Reference Information
  reference_number VARCHAR(100),
  notes TEXT,
  
  -- Performed By
  performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Transaction Date
  transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for inventory_transactions
CREATE INDEX idx_inventory_transactions_inventory_id ON inventory_transactions(inventory_id);
CREATE INDEX idx_inventory_transactions_transaction_type ON inventory_transactions(transaction_type);
CREATE INDEX idx_inventory_transactions_transaction_date ON inventory_transactions(transaction_date);
CREATE INDEX idx_inventory_transactions_performed_by ON inventory_transactions(performed_by);

-- Add RLS policies for inventory_transactions
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;

-- Policy: Clinic staff can view transactions for their clinic inventory
CREATE POLICY "Clinic staff can view inventory transactions"
  ON inventory_transactions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM inventory i
      JOIN clinic_staff cs ON i.clinic_id = cs.clinic_id
      WHERE i.id = inventory_transactions.inventory_id
      AND cs.user_id = auth.uid()
    )
  );

-- Add comments
COMMENT ON TABLE inventory_transactions IS 'Inventory transaction history';
COMMENT ON COLUMN inventory_transactions.transaction_type IS 'Type of transaction: purchase, sale, return, adjustment, transfer, expiry, damage';
COMMENT ON COLUMN inventory_transactions.quantity IS 'Quantity (positive for additions, negative for deductions)';
COMMENT ON COLUMN inventory_transactions.total_cost IS 'Total cost of transaction';

-- ════════════════════════════════════════════════════════════════════════════
-- Stock Update Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update inventory stock on transaction
CREATE OR REPLACE FUNCTION update_inventory_stock()
RETURNS TRIGGER AS $$
BEGIN
  -- Update current stock based on transaction type
  IF NEW.transaction_type IN ('purchase', 'adjustment', 'restock') THEN
    UPDATE inventory
    SET current_stock = current_stock + NEW.quantity
    WHERE id = NEW.inventory_id;
  ELSIF NEW.transaction_type IN ('sale', 'return', 'expiry', 'damage') THEN
    UPDATE inventory
    SET current_stock = current_stock - NEW.quantity
    WHERE id = NEW.inventory_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updating inventory stock
CREATE TRIGGER update_inventory_stock_on_transaction
  AFTER INSERT ON inventory_transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_inventory_stock();

-- ══════════════════════════════════════════════════════════════════════════════
-- Reports Table
-- ════════════════════════════════════════════════════════════════════════════

-- Create reports table for generated reports
CREATE TABLE IF NOT EXISTS reports (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Report Information
  report_name VARCHAR(255) NOT NULL,
  report_name_ar VARCHAR(255),
  report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('appointment', 'patient', 'financial', 'inventory', 'lab_result', 'staff', 'custom')),
  
  -- Foreign Keys
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  generated_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Report Parameters
  start_date DATE,
  end_date DATE,
  parameters JSONB,
  
  -- Report Output
  file_url TEXT,
  file_format VARCHAR(10) DEFAULT 'pdf' CHECK (file_format IN ('pdf', 'xlsx', 'csv', 'json')),
  file_size_bytes BIGINT,
  
  -- Status
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'generating', 'completed', 'failed')),
  error_message TEXT,
  
  -- Statistics
  record_count INTEGER,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for reports
CREATE INDEX idx_reports_clinic_id ON reports(clinic_id);
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_report_type ON reports(report_type);
CREATE INDEX idx_reports_start_date ON reports(start_date);
CREATE INDEX idx_reports_end_date ON reports(end_date);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);

-- Add RLS policies for reports
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

-- Policy: Super admins can manage all reports
CREATE POLICY "Super admins can manage all reports"
  ON reports FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Add comments
COMMENT ON TABLE reports IS 'Generated reports';
COMMENT ON COLUMN reports.report_type IS 'Type of report: appointment, patient, financial, inventory, lab_result, staff, custom';
COMMENT ON COLUMN reports.parameters IS 'JSON object containing report parameters';
COMMENT ON COLUMN reports.file_format IS 'Output file format: pdf, xlsx, csv, json';
COMMENT ON COLUMN reports.status IS 'Report generation status: pending, generating, completed, failed';
COMMENT ON COLUMN reports.record_count IS 'Number of records in the report';
-- Migration: Create Subscription Codes Table
-- Purpose: Store subscription codes for clinic activation
-- Version: v2_P06_001
-- Created: 2026-03-04
-- Dependencies: v2_P02_002_create_clinics_table.sql

-- ════════════════════════════════════════════════════════════════
-- Subscription Codes Table
-- ════════════════════════════════════════════════════════════

-- Create subscription_codes table to store subscription codes
CREATE TABLE IF NOT EXISTS subscription_codes (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Subscription Information
  code VARCHAR(50) NOT NULL UNIQUE NOT NULL,
  type subscription_type NOT NULL CHECK (type IN ('trial', 'monthly', 'quarterly', 'half_yearly', 'yearly')),
  
  -- Pricing (Multi-currency)
  price_usd DECIMAL(10, 2) NOT NULL DEFAULT 0,
  price_eur DECIMAL(10, 2) NOT NULL DEFAULT 0,
  price_dzd DECIMAL(10, 2) NOT NULL DEFAULT 0,
  
  -- Duration
  duration_days INTEGER NOT NULL,
  
  -- Usage Tracking
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  used_at TIMESTAMP WITH TIME ZONE,
  used_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Activation Details
  activated_at TIMESTAMP WITH TIME ZONE,
  activation_notes TEXT,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_expired BOOLEAN NOT NULL DEFAULT false,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_duration CHECK (duration_days > 0),
  CONSTRAINT valid_prices CHECK (
    price_usd >= 0 AND
    price_eur >= 0 AND
    price_dzd >= 0
  )
);

-- Create index on code for faster lookups
CREATE INDEX IF NOT EXISTS idx_subscription_codes_code ON subscription_codes(code);

-- Create index on clinic_id
CREATE INDEX IF NOT EXISTS idx_subscription_codes_clinic_id ON subscription_codes(clinic_id);

-- Create index on is_used
CREATE INDEX IF NOT EXISTS idx_subscription_codes_is_used ON subscription_codes(is_used);

-- Create index on created_at
CREATE INDEX IF NOT EXISTS idx_subscription_codes_created_at ON subscription_codes(created_at DESC);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_subscription_codes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER subscription_codes_updated_at
  BEFORE UPDATE ON subscription_codes
  FOR EACH ROW
  EXECUTE FUNCTION update_subscription_codes_updated_at();

-- Add comments
COMMENT ON TABLE subscription_codes IS 'Subscription codes for clinic activation';
COMMENT ON COLUMN subscription_codes.code IS 'Unique subscription code';
COMMENT ON COLUMN subscription_codes.type IS 'Subscription plan type';
COMMENT ON COLUMN subscription_codes.price_usd IS 'Price in US Dollars';
COMMENT ON COLUMN subscription_codes.price_eur IS 'Price in Euros';
COMMENT ON COLUMN subscription_codes.price_dzd IS 'Price in Algerian Dinars';
COMMENT ON COLUMN subscription_codes.duration_days IS 'Duration in days';
-- Migration: Create Exchange Rates Table
-- Purpose: Store currency exchange rates
-- Version: v2_P06_002
-- Created: 2026-03-04
-- Dependencies: None

-- ════════════════════════════════════════════════════════════════
-- Exchange Rates Table
-- ══════════════════════════════════════════════════════════════

-- Create exchange_rates table to store currency exchange rates
CREATE TABLE IF NOT EXISTS exchange_rates (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Currency Information
  from_currency VARCHAR(3) NOT NULL,
  to_currency VARCHAR(3) NOT NULL,
  rate DECIMAL(10, 6) NOT NULL DEFAULT 1.0,
  
  -- Date Information
  effective_date DATE NOT NULL,
  
  -- Metadata
  source VARCHAR(100),
  is_active BOOLEAN DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  UNIQUE (from_currency, to_currency, effective_date)
);

-- Create indexes for exchange_rates
CREATE INDEX idx_exchange_rates_from_currency ON exchange_rates(from_currency);
CREATE INDEX idx_exchange_rates_to_currency ON exchange_rates(to_currency);
CREATE INDEX idx_exchange_rates_effective_date ON exchange_rates(effective_date DESC);
CREATE INDEX idx_exchange_rates_is_active ON exchange_rates(is_active);

-- Add unique constraint on from_currency, to_currency, effective_date
CREATE UNIQUE INDEX idx_exchange_rates_unique ON exchange_rates(from_currency, to_currency, effective_date);

-- Insert default exchange rates (USD as base)
INSERT INTO exchange_rates (id, from_currency, to_currency, rate, effective_date) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'USD', 'USD', 1.0, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440002', 'USD', 'EUR', 0.92, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440003', 'USD', 'DZD', 134.5, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440004', 'EUR', 'USD', 1.09, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440005', 'EUR', 'EUR', 1.0, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440006', 'EUR', 'DZD', 146.2, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440007', 'DZD', 'USD', 0.0074, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440008', 'DZD', 'EUR', 0.0068, '2026-03-04'),
  ('550e8400-e29b-41d4-a716-446655440009', 'DZD', 'DZD', 1.0, '2026-03-04')
ON CONFLICT (from_currency, to_currency, effective_date) DO NOTHING;

-- ══════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════

-- Enable RLS on exchange_rates table
ALTER TABLE exchange_rates ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active exchange rates
CREATE POLICY "Active exchange rates are viewable by everyone"
  ON exchange_rates FOR SELECT
  USING (is_active = true);

-- Policy: Super admins can manage exchange rates
CREATE POLICY "Super admins can manage exchange rates"
  ON exchange_rates FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_exchange_rates_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exchange_rates_updated_at
  BEFORE UPDATE ON exchange_rates
  FOR EACH ROW
  EXECUTE FUNCTION update_exchange_rates_updated_at();

-- Add comments
COMMENT ON TABLE exchange_rates IS 'Currency exchange rates';
COMMENT ON COLUMN exchange_rates.rate IS 'Exchange rate from base to target currency';
COMMENT ON COLUMN exchange_rates.effective_date IS 'Date when the rate becomes effective';

-- ══════════════════════════════════════════════════════════════
-- Helper Functions
-- ══════════════════════════════════════════════════════════════

-- Function to calculate exchange rate between two currencies
CREATE OR REPLACE FUNCTION calculate_exchange_rate(from_curr VARCHAR(3), to_curr VARCHAR(3))
RETURNS DECIMAL AS $$
DECLARE
  rate DECIMAL;
BEGIN
  SELECT rate INTO rate
  FROM exchange_rates
  WHERE from_currency = from_curr
    AND to_currency = to_currency
    AND is_active = true
    AND effective_date <= CURRENT_DATE
  ORDER BY effective_date DESC
  LIMIT 1;
  
  RETURN COALESCE(rate, 1.0);
END;
$$ LANGUAGE plpgsql;

-- Function to convert amount between currencies
CREATE OR REPLACE FUNCTION convert_currency(amount DECIMAL, from_curr VARCHAR(3), to_curr VARCHAR(3))
RETURNS DECIMAL AS $$
DECLARE
  rate DECIMAL;
BEGIN
  rate := calculate_exchange_rate(from_curr, to_curr);
  RETURN amount * rate;
END;
$$ LANGUAGE plpgsql;

-- Function to get all exchange rates for a base currency
CREATE OR REPLACE FUNCTION get_all_exchange_rates(base_curr VARCHAR(3))
RETURNS TABLE(
  to_currency VARCHAR(3),
  rate DECIMAL,
  effective_date DATE
) AS $$
BEGIN
  RETURN QUERY
  SELECT to_currency, rate, effective_date
  FROM exchange_rates
  WHERE from_currency = base_curr
    AND is_active = true
    AND effective_date <= CURRENT_DATE
  ORDER BY to_currency;
END;
$$ LANGUAGE plpgsql;
-- Migration: Create Notifications Table
-- Purpose: Store user notifications
-- Version: v2_P07_001
-- Created: 2026-03-04
-- Dependencies: v2_P01_004_create_users_table.sql

-- ════════════════════════════════════════════════════════════════════
-- Notifications Table
-- ════════════════════════════════════════════════════════════════

-- Create notifications table to store user notifications
CREATE TABLE IF NOT EXISTS notifications (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Notification Information
  title VARCHAR(255) NOT NULL,
  title_ar VARCHAR(255),
  body TEXT NOT NULL,
  body_ar TEXT,
  type VARCHAR(50) DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error', 'appointment', 'prescription', 'lab_result', 'invoice', 'system', 'alert')),
  
  -- Related Entity
  data JSONB,
  related_entity_type VARCHAR(50),
  related_entity_id UUID,
  
  -- Status
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP WITH TIME ZONE,
  action_url TEXT,
  action_label VARCHAR(100),
  
  -- Priority
  priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  
  -- Expiration
  expires_at TIMESTAMP WITH TIME ZONE,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ══════════════════════════════════════════════════════════════════
-- Indexes
-- ════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_related_entity ON notifications(related_entity_type, related_entity_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX idx_notifications_expires_at ON notifications(expires_at);

-- ════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════

-- Enable RLS on notifications table
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notifications
CREATE POLICY "Users can view their own notifications"
  ON notifications FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Users can update their own notifications
CREATE POLICY "Users can update their own notifications"
  ON notifications FOR UPDATE
  USING (user_id = auth.uid());

-- Policy: System can create notifications for any user
CREATE POLICY "System can create notifications"
  ON notifications FOR INSERT
  WITH CHECK (true);

-- Policy: Super admins can manage all notifications
CREATE POLICY "Super admins can manage all notifications"
  ON notifications FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════

COMMENT ON TABLE notifications IS 'User notifications';
COMMENT ON COLUMN notifications.type IS 'Notification type: info, success, warning, error, appointment, prescription, lab_result, invoice, system, alert';
COMMENT ON COLUMN notifications.data IS 'Additional data in JSON format';
COMMENT ON COLUMN notifications.related_entity_type IS 'Type of related entity (e.g., appointment, prescription)';
COMMENT ON COLUMN notifications.related_entity_id IS 'ID of related entity';
COMMENT ON COLUMN notifications.priority IS 'Notification priority: low, normal, high, urgent';

-- ════════════════════════════════════════════════════════════════
-- Notification Settings Table
-- ══════════════════════════════════════════════════════════════

-- Create notification_settings table for user notification preferences
CREATE TABLE IF NOT EXISTS notification_settings (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,

  -- Notification Preferences
  email_notifications BOOLEAN DEFAULT true,
  push_notifications BOOLEAN DEFAULT true,
  sms_notifications BOOLEAN DEFAULT false,
  appointment_reminders BOOLEAN DEFAULT true,
  prescription_alerts BOOLEAN DEFAULT true,
  lab_result_alerts BOOLEAN DEFAULT true,
  invoice_alerts BOOLEAN DEFAULT true,
  
  -- Quiet Hours
  quiet_hours_start TIME,
  quiet_hours_end TIME,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for notification_settings
CREATE INDEX idx_notification_settings_user_id ON notification_settings(user_id);

-- Add RLS policies for notification_settings
ALTER TABLE notification_settings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notification settings
CREATE POLICY "Users can view their own notification settings"
  ON notification_settings FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Users can update their own notification settings
CREATE POLICY "Users can update their own notification settings"
  ON notification_settings FOR UPDATE
  USING (user_id = auth.uid());

-- Create trigger for updated_at
CREATE TRIGGER update_notification_settings_updated_at
  BEFORE UPDATE ON notification_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_notification_settings_updated_at();

-- Add comments
COMMENT ON TABLE notification_settings IS 'User notification preferences';
COMMENT ON COLUMN notification_settings.quiet_hours_start IS 'Start time for quiet hours (no notifications)';
COMMENT ON COLUMN notification_settings.quiet_hours_end IS 'End time for quiet hours (no notifications)';

-- ════════════════════════════════════════════════════════════════
-- Autism Assessments Table
-- ════════════════════════════════════════════════════════════

-- Create autism_assessments table
CREATE TABLE IF NOT EXISTS autism_assessments (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- Assessment Information
  assessment_date DATE NOT NULL,
  assessment_type VARCHAR(50),
  age_at_assessment_months INTEGER,
  
  -- Developmental Milestones
  developmental_milestones JSONB,
  behavioral_observations JSONB,
  communication_skills JSONB,
  social_interaction JSONB,
  repetitive_behaviors JSONB,
  sensory_issues JSONB,
  
  -- Clinical Information
  screening_tools JSONB,
  screening_score INTEGER,
  screening_result VARCHAR(50),
  diagnosis VARCHAR(100),
  severity_level VARCHAR(50),
  
  -- Recommendations
  recommendations TEXT[],
  follow_up_required BOOLEAN DEFAULT false,
  follow_up_date DATE,
  
  -- Parent Information
  parent_concerns TEXT,
  family_history TEXT,
  
  -- System Fields
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

-- Policy: Super admins can manage all assessments
CREATE POLICY "Super admins can manage all assessments"
  ON autism_assessments FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Create trigger for updated_at
CREATE TRIGGER update_autism_assessments_updated_at
  BEFORE UPDATE ON autism_assessments
  FOR EACH ROW
  EXECUTE FUNCTION update_autism_assessments_updated_at();

-- Add comments
COMMENT ON TABLE autism_assessments IS 'Autism spectrum disorder assessments';
COMMENT ON COLUMN autism_assessments.developmental_milestones IS 'JSON object containing developmental milestones assessment';
COMMENT ON COLUMN autism_assessments.behavioral_observations IS 'JSON object containing behavioral observations';
COMMENT ON COLUMN autism_assessments.screening_score IS 'Score from screening tools';
COMMENT ON COLUMN autism_assessments.diagnosis IS 'Final diagnosis if any';
COMMENT ON COLUMN autism_assessments.severity_level IS 'Severity level of diagnosis';
COMMENT ON COLUMN autism_assessments.parent_concerns IS 'Parent concerns about child development';

-- ══════════════════════════════════════════════════════════════
-- Bug Reports Table
-- ══════════════════════════════════════════════════════════════

-- Create bug_reports table
CREATE TABLE IF NOT EXISTS bug_reports (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Bug Report Information
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) CHECK (category IN ('ui', 'functionality', 'performance', 'security', 'other')),
  severity VARCHAR(20) DEFAULT 'low' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed', 'reopened')),
  
  -- Device Information
  platform VARCHAR(50),
  app_version VARCHAR(50),
  device_info JSONB,
  screenshot_url TEXT,
  
  -- Reproduction Steps
  reproduction_steps TEXT[],
  expected_behavior TEXT,
  actual_behavior TEXT,
  
  -- Assignment Information
  assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
  resolution_notes TEXT,
  resolved_at TIMESTAMP WITH TIME ZONE,
  
  -- System Fields
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
  EXECUTE FUNCTION update_bug_reports_updated_at();

-- Add comments
COMMENT ON TABLE bug_reports IS 'Bug reports and issues';
COMMENT ON COLUMN bug_reports.category IS 'Bug category: ui, functionality, performance, security, other';
COMMENT ON COLUMN bug_reports.severity IS 'Bug severity: low, medium, high, critical';
COMMENT ON COLUMN bug_reports.status IS 'Bug status: open, in_progress, resolved, closed, reopened';
COMMENT ON COLUMN bug_reports.device_info IS 'JSON object containing device and browser information';
-- Migration: Create Prescription Items Table
-- Purpose: Store individual medication items in prescriptions
-- Version: v2_P04_003
-- Created: 2026-03-04
-- Dependencies: 20260304120012_create_prescriptions_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Prescription Items Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create prescription_items table to store individual medication items
CREATE TABLE IF NOT EXISTS prescription_items (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,

  -- Medication Information
  medication_name VARCHAR(255) NOT NULL,
  medication_name_ar VARCHAR(255),
  generic_name VARCHAR(255),
  brand_name VARCHAR(255),
  
  -- Dosage Information
  dosage VARCHAR(100) NOT NULL,
  dosage_unit VARCHAR(50) NOT NULL, -- mg, ml, tablets, etc.
  frequency VARCHAR(100) NOT NULL, -- Once daily, twice daily, etc.
  route VARCHAR(50) NOT NULL, -- Oral, IV, IM, etc.
  
  -- Duration
  duration_days INTEGER NOT NULL,
  total_quantity DECIMAL(10, 2) NOT NULL,
  
  -- Instructions
  instructions TEXT,
  instructions_ar TEXT,
  special_instructions TEXT,
  special_instructions_ar TEXT,
  
  -- Safety Information
  side_effects TEXT,
  contraindications TEXT,
  warnings TEXT,
  
  -- Pricing
  unit_price DECIMAL(10, 2) DEFAULT 0.00,
  total_price DECIMAL(10, 2) DEFAULT 0.00,
  currency VARCHAR(3) DEFAULT 'USD',
  
  -- Dispensing
  is_dispensed BOOLEAN NOT NULL DEFAULT false,
  dispensed_at TIMESTAMP WITH TIME ZONE,
  dispensed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_duration CHECK (duration_days > 0),
  CONSTRAINT valid_quantity CHECK (total_quantity > 0),
  CONSTRAINT valid_prices CHECK (unit_price >= 0 AND total_price >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_prescription_items_prescription_id ON prescription_items(prescription_id);
CREATE INDEX idx_prescription_items_medication_name ON prescription_items(medication_name) WHERE is_active = true;
CREATE INDEX idx_prescription_items_is_dispensed ON prescription_items(is_dispensed);
CREATE INDEX idx_prescription_items_is_active ON prescription_items(is_active);
CREATE INDEX idx_prescription_items_created_at ON prescription_items(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on prescription_items table
ALTER TABLE prescription_items ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own prescription items
CREATE POLICY "Patients can view their own prescription items"
  ON prescription_items FOR SELECT
  USING (
    prescription_id IN (
      SELECT id FROM prescriptions
      WHERE patient_id = auth.uid()
    )
  );

-- Policy: Doctors can view prescription items for their patients
CREATE POLICY "Doctors can view prescription items for their patients"
  ON prescription_items FOR SELECT
  USING (
    prescription_id IN (
      SELECT id FROM prescriptions
      WHERE doctor_id IN (
        SELECT id FROM doctors WHERE user_id = auth.uid()
      )
    )
  );

-- Policy: Clinic staff can view clinic prescription items
CREATE POLICY "Clinic staff can view clinic prescription items"
  ON prescription_items FOR SELECT
  USING (
    prescription_id IN (
      SELECT id FROM prescriptions
      WHERE clinic_id IN (
        SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
      )
    )
  );

-- Policy: Doctors can create prescription items
CREATE POLICY "Doctors can create prescription items"
  ON prescription_items FOR INSERT
  WITH CHECK (
    prescription_id IN (
      SELECT id FROM prescriptions
      WHERE doctor_id IN (
        SELECT id FROM doctors WHERE user_id = auth.uid()
      )
    )
  );

-- Policy: Doctors can update prescription items
CREATE POLICY "Doctors can update prescription items"
  ON prescription_items FOR UPDATE
  USING (
    prescription_id IN (
      SELECT id FROM prescriptions
      WHERE doctor_id IN (
        SELECT id FROM doctors WHERE user_id = auth.uid()
      )
    )
  );

-- Policy: Super admins can manage all prescription items
CREATE POLICY "Super admins can manage all prescription items"
  ON prescription_items FOR ALL
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
CREATE OR REPLACE FUNCTION update_prescription_items_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER prescription_items_update_updated_at
  BEFORE UPDATE ON prescription_items
  FOR EACH ROW
  EXECUTE FUNCTION update_prescription_items_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE prescription_items IS 'Individual medication items in prescriptions';
COMMENT ON COLUMN prescription_items.id IS 'Primary key (UUID)';
COMMENT ON COLUMN prescription_items.prescription_id IS 'Reference to prescription';
COMMENT ON COLUMN prescription_items.medication_name IS 'Medication name';
COMMENT ON COLUMN prescription_items.dosage IS 'Dosage amount';
COMMENT ON COLUMN prescription_items.dosage_unit IS 'Dosage unit (mg, ml, tablets, etc.)';
COMMENT ON COLUMN prescription_items.frequency IS 'Frequency of administration';
COMMENT ON COLUMN prescription_items.route IS 'Route of administration';
COMMENT ON COLUMN prescription_items.duration_days IS 'Duration in days';
COMMENT ON COLUMN prescription_items.total_quantity IS 'Total quantity to dispense';
COMMENT ON COLUMN prescription_items.instructions IS 'Instructions for use';
COMMENT ON COLUMN prescription_items.is_dispensed IS 'Whether the medication has been dispensed';
-- Migration: Create Vital Signs Table
-- Purpose: Store patient vital signs measurements
-- Version: v2_P04_005
-- Created: 2026-03-04
-- Dependencies: 20260304120008_create_patients_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Vital Signs Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create vital_signs table to store patient vital signs
CREATE TABLE IF NOT EXISTS vital_signs (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,

  -- Vital Signs
  -- Blood Pressure
  systolic_bp INTEGER, -- mmHg
  diastolic_bp INTEGER, -- mmHg
  bp_position VARCHAR(50), -- Sitting, standing, lying
  bp_arm VARCHAR(50), -- Left, right
  
  -- Heart Rate
  heart_rate INTEGER, -- beats per minute
  heart_rate_rhythm VARCHAR(50), -- Regular, irregular
  heart_rate_location VARCHAR(50), -- Apex, radial, etc.
  
  -- Respiratory Rate
  respiratory_rate INTEGER, -- breaths per minute
  respiratory_pattern VARCHAR(50), -- Regular, irregular, labored
  
  -- Temperature
  temperature DECIMAL(5, 2), -- Celsius
  temperature_method VARCHAR(50), -- Oral, rectal, axillary, tympanic
  temperature_unit VARCHAR(10) DEFAULT 'C',
  
  -- Oxygen Saturation
  oxygen_saturation DECIMAL(5, 2), -- SpO2 percentage
  oxygen_supplement BOOLEAN DEFAULT false,
  oxygen_flow_rate DECIMAL(5, 2), -- L/min
  oxygen_method VARCHAR(50), -- Nasal cannula, mask, etc.
  
  -- Weight
  weight DECIMAL(10, 2), -- kg
  weight_unit VARCHAR(10) DEFAULT 'kg',
  
  -- Height
  height DECIMAL(10, 2), -- cm
  height_unit VARCHAR(10) DEFAULT 'cm',
  
  -- Body Mass Index
  bmi DECIMAL(5, 2),
  
  -- Pain Assessment
  pain_score INTEGER CHECK (pain_score >= 0 AND pain_score <= 10),
  pain_scale VARCHAR(50), -- Numeric, FLACC, Wong-Baker, etc.
  pain_location TEXT,
  pain_description TEXT,
  
  -- Additional Measurements
  blood_glucose DECIMAL(5, 2), -- mg/dL
  blood_glucose_unit VARCHAR(10) DEFAULT 'mg/dL',
  blood_glucose_timing VARCHAR(50), -- Fasting, pre-meal, post-meal
  
  -- Consciousness
  consciousness_level VARCHAR(50), -- Alert, drowsy, confused, unconscious
  glasgow_coma_scale INTEGER CHECK (glasgow_coma_scale >= 3 AND glasgow_coma_scale <= 15),
  
  -- Notes
  notes TEXT,
  notes_ar TEXT,
  
  -- Abnormal Flags
  is_abnormal BOOLEAN NOT NULL DEFAULT false,
  abnormal_findings TEXT,
  
  -- System Fields
  measured_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  measured_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_bp CHECK (
    (systolic_bp IS NULL AND diastolic_bp IS NULL) OR
    (systolic_bp IS NOT NULL AND diastolic_bp IS NOT NULL AND systolic_bp > diastolic_bp)
  ),
  CONSTRAINT valid_heart_rate CHECK (heart_rate IS NULL OR heart_rate > 0),
  CONSTRAINT valid_respiratory_rate CHECK (respiratory_rate IS NULL OR respiratory_rate > 0),
  CONSTRAINT valid_temperature CHECK (temperature IS NULL OR temperature > 0),
  CONSTRAINT valid_oxygen_saturation CHECK (oxygen_saturation IS NULL OR (oxygen_saturation >= 0 AND oxygen_saturation <= 100)),
  CONSTRAINT valid_weight CHECK (weight IS NULL OR weight > 0),
  CONSTRAINT valid_height CHECK (height IS NULL OR height > 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_vital_signs_patient_id ON vital_signs(patient_id);
CREATE INDEX idx_vital_signs_appointment_id ON vital_signs(appointment_id);
CREATE INDEX idx_vital_signs_doctor_id ON vital_signs(doctor_id);
CREATE INDEX idx_vital_signs_clinic_id ON vital_signs(clinic_id);
CREATE INDEX idx_vital_signs_measured_at ON vital_signs(measured_at DESC);
CREATE INDEX idx_vital_signs_measured_by ON vital_signs(measured_by);
CREATE INDEX idx_vital_signs_is_abnormal ON vital_signs(is_abnormal);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on vital_signs table
ALTER TABLE vital_signs ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own vital signs
CREATE POLICY "Patients can view their own vital signs"
  ON vital_signs FOR SELECT
  USING (patient_id IN (
    SELECT id FROM patients WHERE user_id = auth.uid()
  ));

-- Policy: Doctors can view vital signs for their patients
CREATE POLICY "Doctors can view vital signs for their patients"
  ON vital_signs FOR SELECT
  USING (
    doctor_id IN (
      SELECT id FROM doctors WHERE user_id = auth.uid()
    ) OR
    clinic_id IN (
      SELECT clinic_id FROM doctors WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can view clinic vital signs
CREATE POLICY "Clinic staff can view clinic vital signs"
  ON vital_signs FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
    )
  );

-- Policy: Doctors and nurses can create vital signs
CREATE POLICY "Doctors and nurses can create vital signs"
  ON vital_signs FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('doctor', 'nurse')
    )
  );

-- Policy: Doctors and nurses can update vital signs
CREATE POLICY "Doctors and nurses can update vital signs"
  ON vital_signs FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM clinic_staff
      WHERE user_id = auth.uid()
      AND role IN ('doctor', 'nurse')
    )
  );

-- Policy: Super admins can manage all vital signs
CREATE POLICY "Super admins can manage all vital signs"
  ON vital_signs FOR ALL
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
CREATE OR REPLACE FUNCTION update_vital_signs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER vital_signs_update_updated_at
  BEFORE UPDATE ON vital_signs
  FOR EACH ROW
  EXECUTE FUNCTION update_vital_signs_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE vital_signs IS 'Patient vital signs measurements';
COMMENT ON COLUMN vital_signs.id IS 'Primary key (UUID)';
COMMENT ON COLUMN vital_signs.systolic_bp IS 'Systolic blood pressure (mmHg)';
COMMENT ON COLUMN vital_signs.diastolic_bp IS 'Diastolic blood pressure (mmHg)';
COMMENT ON COLUMN vital_signs.heart_rate IS 'Heart rate (beats per minute)';
COMMENT ON COLUMN vital_signs.respiratory_rate IS 'Respiratory rate (breaths per minute)';
COMMENT ON COLUMN vital_signs.temperature IS 'Body temperature (Celsius)';
COMMENT ON COLUMN vital_signs.oxygen_saturation IS 'Oxygen saturation (SpO2 %)';
COMMENT ON COLUMN vital_signs.weight IS 'Weight (kg)';
COMMENT ON COLUMN vital_signs.height IS 'Height (cm)';
COMMENT ON COLUMN vital_signs.bmi IS 'Body Mass Index';
COMMENT ON COLUMN vital_signs.pain_score IS 'Pain score (0-10)';
COMMENT ON COLUMN vital_signs.blood_glucose IS 'Blood glucose (mg/dL)';
COMMENT ON COLUMN vital_signs.glasgow_coma_scale IS 'Glasgow Coma Scale (3-15)';
COMMENT ON COLUMN vital_signs.is_abnormal IS 'Whether vital signs are abnormal';
-- Migration: Create Invoice Items Table
-- Purpose: Store individual line items in invoices
-- Version: v2_P05_002
-- Created: 2026-03-04
-- Dependencies: 20260304120015_create_invoices_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Invoice Items Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create invoice_items table to store individual line items in invoices
CREATE TABLE IF NOT EXISTS invoice_items (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,

  -- Item Information
  item_type VARCHAR(50) NOT NULL CHECK (item_type IN ('consultation', 'procedure', 'medication', 'lab_test', 'imaging', 'service', 'other')),
  item_code VARCHAR(50),
  item_name VARCHAR(255) NOT NULL,
  item_name_ar VARCHAR(255),
  description TEXT,
  description_ar TEXT,

  -- Quantity and Pricing
  quantity DECIMAL(10, 2) NOT NULL DEFAULT 1.0,
  unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  discount_percent DECIMAL(5, 2) DEFAULT 0.00,
  discount_amount DECIMAL(10, 2) DEFAULT 0.00,
  tax_percent DECIMAL(5, 2) DEFAULT 0.00,
  tax_amount DECIMAL(10, 2) DEFAULT 0.00,
  subtotal DECIMAL(10, 2) NOT NULL,
  total DECIMAL(10, 2) NOT NULL,

  -- Currency
  currency VARCHAR(3) DEFAULT 'USD',

  -- Service Details
  service_date TIMESTAMP WITH TIME ZONE,
  performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,

  -- Inventory Reference
  inventory_item_id UUID REFERENCES inventory(id) ON DELETE SET NULL,
  batch_number VARCHAR(50),
  expiry_date DATE,

  -- Status
  is_billed BOOLEAN NOT NULL DEFAULT false,
  is_paid BOOLEAN NOT NULL DEFAULT false,
  is_refunded BOOLEAN NOT NULL DEFAULT false,
  refund_amount DECIMAL(10, 2) DEFAULT 0.00,
  refund_reason TEXT,

  -- Notes
  notes TEXT,
  notes_ar TEXT,

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_quantity CHECK (quantity > 0),
  CONSTRAINT valid_unit_price CHECK (unit_price >= 0),
  CONSTRAINT valid_discount CHECK (discount_percent >= 0 AND discount_percent <= 100),
  CONSTRAINT valid_tax CHECK (tax_percent >= 0 AND tax_percent <= 100),
  CONSTRAINT valid_subtotal CHECK (subtotal >= 0),
  CONSTRAINT valid_total CHECK (total >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX idx_invoice_items_appointment_id ON invoice_items(appointment_id);
CREATE INDEX idx_invoice_items_item_type ON invoice_items(item_type);
CREATE INDEX idx_invoice_items_item_code ON invoice_items(item_code);
CREATE INDEX idx_invoice_items_performed_by ON invoice_items(performed_by);
CREATE INDEX idx_invoice_items_doctor_id ON invoice_items(doctor_id);
CREATE INDEX idx_invoice_items_inventory_item_id ON invoice_items(inventory_item_id);
CREATE INDEX idx_invoice_items_is_billed ON invoice_items(is_billed);
CREATE INDEX idx_invoice_items_is_paid ON invoice_items(is_paid);
CREATE INDEX idx_invoice_items_is_refunded ON invoice_items(is_refunded);
CREATE INDEX idx_invoice_items_created_at ON invoice_items(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on invoice_items table
ALTER TABLE invoice_items ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can view their own invoice items
CREATE POLICY "Patients can view their own invoice items"
  ON invoice_items FOR SELECT
  USING (
    invoice_id IN (
      SELECT id FROM invoices
      WHERE patient_id IN (
        SELECT id FROM patients WHERE user_id = auth.uid()
      )
    )
  );

-- Policy: Clinic staff can view clinic invoice items
CREATE POLICY "Clinic staff can view clinic invoice items"
  ON invoice_items FOR SELECT
  USING (
    invoice_id IN (
      SELECT id FROM invoices
      WHERE clinic_id IN (
        SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
      )
    )
  );

-- Policy: Clinic staff can create invoice items
CREATE POLICY "Clinic staff can create invoice items"
  ON invoice_items FOR INSERT
  WITH CHECK (
    invoice_id IN (
      SELECT id FROM invoices
      WHERE clinic_id IN (
        SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
        AND role IN ('admin', 'manager', 'receptionist', 'technician')
      )
    )
  );

-- Policy: Clinic staff can update invoice items
CREATE POLICY "Clinic staff can update invoice items"
  ON invoice_items FOR UPDATE
  USING (
    invoice_id IN (
      SELECT id FROM invoices
      WHERE clinic_id IN (
        SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
        AND role IN ('admin', 'manager', 'receptionist', 'technician')
      )
    )
  );

-- Policy: Super admins can manage all invoice items
CREATE POLICY "Super admins can manage all invoice items"
  ON invoice_items FOR ALL
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
CREATE OR REPLACE FUNCTION update_invoice_items_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER invoice_items_update_updated_at
  BEFORE UPDATE ON invoice_items
  FOR EACH ROW
  EXECUTE FUNCTION update_invoice_items_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE invoice_items IS 'Individual line items in invoices';
COMMENT ON COLUMN invoice_items.id IS 'Primary key (UUID)';
COMMENT ON COLUMN invoice_items.invoice_id IS 'Reference to invoice';
COMMENT ON COLUMN invoice_items.appointment_id IS 'Reference to appointment';
COMMENT ON COLUMN invoice_items.item_type IS 'Type of item (consultation, procedure, medication, etc.)';
COMMENT ON COLUMN invoice_items.item_name IS 'Name of the item';
COMMENT ON COLUMN invoice_items.quantity IS 'Quantity';
COMMENT ON COLUMN invoice_items.unit_price IS 'Price per unit';
COMMENT ON COLUMN invoice_items.discount_percent IS 'Discount percentage';
COMMENT ON COLUMN invoice_items.tax_percent IS 'Tax percentage';
COMMENT ON COLUMN invoice_items.subtotal IS 'Subtotal before tax and discount';
COMMENT ON COLUMN invoice_items.total IS 'Total after tax and discount';
COMMENT ON COLUMN invoice_items.is_billed IS 'Whether the item has been billed';
COMMENT ON COLUMN invoice_items.is_paid IS 'Whether the item has been paid';
COMMENT ON COLUMN invoice_items.is_refunded IS 'Whether the item has been refunded';
-- Migration: Create Inventory Transactions Table
-- Purpose: Track inventory stock movements
-- Version: v2_P05_004
-- Created: 2026-03-04
-- Dependencies: 20260304120016_create_inventory_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory Transactions Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create inventory_transactions table to track inventory stock movements
CREATE TABLE IF NOT EXISTS inventory_transactions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  inventory_item_id UUID NOT NULL REFERENCES inventory(id) ON DELETE CASCADE,
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  related_invoice_item_id UUID REFERENCES invoice_items(id) ON DELETE SET NULL,
  related_prescription_item_id UUID REFERENCES prescription_items(id) ON DELETE SET NULL,

  -- Transaction Information
  transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'return', 'adjustment', 'transfer', 'expiry', 'damage', 'loss')),
  
  -- Quantity Changes
  quantity_before DECIMAL(10, 2) NOT NULL,
  quantity_change DECIMAL(10, 2) NOT NULL,
  quantity_after DECIMAL(10, 2) NOT NULL,
  
  -- Cost and Value
  unit_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  total_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  currency VARCHAR(3) DEFAULT 'USD',
  
  -- Batch Information
  batch_number VARCHAR(50),
  lot_number VARCHAR(50),
  serial_number VARCHAR(100),
  expiry_date DATE,
  manufacturing_date DATE,
  
  -- Supplier Information
  supplier_id UUID,
  supplier_name VARCHAR(255),
  supplier_contact VARCHAR(255),
  
  -- Transfer Information (for transfer transactions)
  from_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  to_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  transfer_reference VARCHAR(100),
  
  -- Reason and Notes
  reason VARCHAR(255),
  notes TEXT,
  notes_ar TEXT,
  
  -- Reference Information
  reference_number VARCHAR(100),
  reference_type VARCHAR(50), -- PO, SO, ADJUSTMENT, etc.
  
  -- Approval
  requires_approval BOOLEAN DEFAULT false,
  approved_by UUID REFERENCES users(id) ON DELETE SET NULL,
  approved_at TIMESTAMP WITH TIME ZONE,
  approval_notes TEXT,
  
  -- System Fields
  transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_quantity_change CHECK (quantity_change != 0),
  CONSTRAINT valid_quantity_after CHECK (quantity_after >= 0),
  CONSTRAINT valid_unit_cost CHECK (unit_cost >= 0),
  CONSTRAINT valid_total_cost CHECK (total_cost >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_inventory_transactions_inventory_item_id ON inventory_transactions(inventory_item_id);
CREATE INDEX idx_inventory_transactions_clinic_id ON inventory_transactions(clinic_id);
CREATE INDEX idx_inventory_transactions_related_invoice_item_id ON inventory_transactions(related_invoice_item_id);
CREATE INDEX idx_inventory_transactions_related_prescription_item_id ON inventory_transactions(related_prescription_item_id);
CREATE INDEX idx_inventory_transactions_transaction_type ON inventory_transactions(transaction_type);
CREATE INDEX idx_inventory_transactions_batch_number ON inventory_transactions(batch_number);
CREATE INDEX idx_inventory_transactions_expiry_date ON inventory_transactions(expiry_date);
CREATE INDEX idx_inventory_transactions_supplier_id ON inventory_transactions(supplier_id);
CREATE INDEX idx_inventory_transactions_from_clinic_id ON inventory_transactions(from_clinic_id);
CREATE INDEX idx_inventory_transactions_to_clinic_id ON inventory_transactions(to_clinic_id);
CREATE INDEX idx_inventory_transactions_reference_number ON inventory_transactions(reference_number);
CREATE INDEX idx_inventory_transactions_transaction_date ON inventory_transactions(transaction_date DESC);
CREATE INDEX idx_inventory_transactions_created_by ON inventory_transactions(created_by);
CREATE INDEX idx_inventory_transactions_approved_by ON inventory_transactions(approved_by);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on inventory_transactions table
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;

-- Policy: Clinic staff can view clinic inventory transactions
CREATE POLICY "Clinic staff can view clinic inventory transactions"
  ON inventory_transactions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can create inventory transactions
CREATE POLICY "Clinic staff can create inventory transactions"
  ON inventory_transactions FOR INSERT
  WITH CHECK (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
      AND role IN ('admin', 'manager', 'technician', 'nurse')
    )
  );

-- Policy: Super admins can manage all inventory transactions
CREATE POLICY "Super admins can manage all inventory transactions"
  ON inventory_transactions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE inventory_transactions IS 'Inventory stock movements tracking';
COMMENT ON COLUMN inventory_transactions.id IS 'Primary key (UUID)';
COMMENT ON COLUMN inventory_transactions.inventory_item_id IS 'Reference to inventory item';
COMMENT ON COLUMN inventory_transactions.clinic_id IS 'Reference to clinic';
COMMENT ON COLUMN inventory_transactions.transaction_type IS 'Type of transaction (purchase, sale, return, etc.)';
COMMENT ON COLUMN inventory_transactions.quantity_before IS 'Quantity before transaction';
COMMENT ON COLUMN inventory_transactions.quantity_change IS 'Quantity change (positive for additions, negative for deductions)';
COMMENT ON COLUMN inventory_transactions.quantity_after IS 'Quantity after transaction';
COMMENT ON COLUMN inventory_transactions.unit_cost IS 'Cost per unit';
COMMENT ON COLUMN inventory_transactions.total_cost IS 'Total cost';
COMMENT ON COLUMN inventory_transactions.batch_number IS 'Batch number';
COMMENT ON COLUMN inventory_transactions.expiry_date IS 'Expiry date';
COMMENT ON COLUMN inventory_transactions.supplier_name IS 'Supplier name';
COMMENT ON COLUMN inventory_transactions.transaction_date IS 'Date of transaction';
COMMENT ON COLUMN inventory_transactions.created_by IS 'User who created the transaction';
-- Migration: Create Notification Settings Table
-- Purpose: Store user notification preferences
-- Version: v2_P07_002
-- Created: 2026-03-04
-- Dependencies: 20260304120001_create_users_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Notification Settings Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create notification_settings table to store user notification preferences
CREATE TABLE IF NOT EXISTS notification_settings (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE,

  -- Email Notifications
  email_appointments BOOLEAN NOT NULL DEFAULT true,
  email_prescriptions BOOLEAN NOT NULL DEFAULT true,
  email_lab_results BOOLEAN NOT NULL DEFAULT true,
  email_invoices BOOLEAN NOT NULL DEFAULT true,
  email_promotions BOOLEAN NOT NULL DEFAULT false,
  email_system_updates BOOLEAN NOT NULL DEFAULT true,

  -- Push Notifications
  push_appointments BOOLEAN NOT NULL DEFAULT true,
  push_prescriptions BOOLEAN NOT NULL DEFAULT true,
  push_lab_results BOOLEAN NOT NULL DEFAULT true,
  push_invoices BOOLEAN NOT NULL DEFAULT true,
  push_promotions BOOLEAN NOT NULL DEFAULT false,
  push_system_updates BOOLEAN NOT NULL DEFAULT true,

  -- SMS Notifications
  sms_appointments BOOLEAN NOT NULL DEFAULT true,
  sms_prescriptions BOOLEAN NOT NULL DEFAULT false,
  sms_lab_results BOOLEAN NOT NULL DEFAULT false,
  sms_invoices BOOLEAN NOT NULL DEFAULT false,
  sms_promotions BOOLEAN NOT NULL DEFAULT false,
  sms_system_updates BOOLEAN NOT NULL DEFAULT false,

  -- In-App Notifications
  inapp_appointments BOOLEAN NOT NULL DEFAULT true,
  inapp_prescriptions BOOLEAN NOT NULL DEFAULT true,
  inapp_lab_results BOOLEAN NOT NULL DEFAULT true,
  inapp_invoices BOOLEAN NOT NULL DEFAULT true,
  inapp_promotions BOOLEAN NOT NULL DEFAULT true,
  inapp_system_updates BOOLEAN NOT NULL DEFAULT true,

  -- Notification Timing
  quiet_hours_enabled BOOLEAN NOT NULL DEFAULT false,
  quiet_hours_start TIME,
  quiet_hours_end TIME,
  timezone VARCHAR(50) DEFAULT 'UTC',

  -- Notification Frequency
  daily_summary BOOLEAN NOT NULL DEFAULT false,
  weekly_summary BOOLEAN NOT NULL DEFAULT false,
  monthly_summary BOOLEAN NOT NULL DEFAULT false,

  -- Device Settings
  device_token VARCHAR(500),
  platform VARCHAR(50), -- ios, android, web, windows, macos
  app_version VARCHAR(50),
  last_active_at TIMESTAMP WITH TIME ZONE,

  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_quiet_hours CHECK (
    NOT quiet_hours_enabled OR
    (quiet_hours_start IS NOT NULL AND quiet_hours_end IS NOT NULL)
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_notification_settings_user_id ON notification_settings(user_id);
CREATE INDEX idx_notification_settings_device_token ON notification_settings(device_token);
CREATE INDEX idx_notification_settings_platform ON notification_settings(platform);
CREATE INDEX idx_notification_settings_created_at ON notification_settings(created_at DESC);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on notification_settings table
ALTER TABLE notification_settings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own notification settings
CREATE POLICY "Users can view their own notification settings"
  ON notification_settings FOR SELECT
  USING (user_id = auth.uid());

-- Policy: Users can create their own notification settings
CREATE POLICY "Users can create their own notification settings"
  ON notification_settings FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Policy: Users can update their own notification settings
CREATE POLICY "Users can update their own notification settings"
  ON notification_settings FOR UPDATE
  USING (user_id = auth.uid());

-- Policy: Super admins can manage all notification settings
CREATE POLICY "Super admins can manage all notification settings"
  ON notification_settings FOR ALL
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
CREATE OR REPLACE FUNCTION update_notification_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER notification_settings_update_updated_at
  BEFORE UPDATE ON notification_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_notification_settings_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE notification_settings IS 'User notification preferences';
COMMENT ON COLUMN notification_settings.id IS 'Primary key (UUID)';
COMMENT ON COLUMN notification_settings.user_id IS 'Reference to user';
COMMENT ON COLUMN notification_settings.email_appointments IS 'Email notifications for appointments';
COMMENT ON COLUMN notification_settings.push_appointments IS 'Push notifications for appointments';
COMMENT ON COLUMN notification_settings.sms_appointments IS 'SMS notifications for appointments';
COMMENT ON COLUMN notification_settings.inapp_appointments IS 'In-app notifications for appointments';
COMMENT ON COLUMN notification_settings.quiet_hours_enabled IS 'Whether quiet hours are enabled';
COMMENT ON COLUMN notification_settings.quiet_hours_start IS 'Quiet hours start time';
COMMENT ON COLUMN notification_settings.quiet_hours_end IS 'Quiet hours end time';
COMMENT ON COLUMN notification_settings.device_token IS 'FCM device token';
COMMENT ON COLUMN notification_settings.platform IS 'Device platform';
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
-- Migration: Fix Countries Table Public Access
-- Purpose: Fix RLS policies to allow public/unauthenticated access to countries
-- Version: v2_P01_002_fix
-- Created: 2026-03-12
-- Status: CRITICAL FIX

-- ══════════════════════════════════════════════════════════════════════════════
-- Issue: Users during registration/login get 404 when fetching countries
-- Fix: Add explicit policy for public access
-- ══════════════════════════════════════════════════════════════════════════════

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Active countries are viewable by everyone" ON countries;
DROP POLICY IF EXISTS "Supported countries are viewable by everyone" ON countries;
DROP POLICY IF EXISTS "Service role can manage countries" ON countries;
DROP POLICY IF EXISTS "Public can read countries" ON countries;

-- ══════════════════════════════════════════════════════════════════════════════
-- New RLS Policies - Allows public access
-- ══════════════════════════════════════════════════════════════════════════════

-- Policy 1: Everyone (authenticated or not) can view all supported countries
CREATE POLICY "Public read access to supported countries"
  ON countries FOR SELECT
  USING (is_supported = true);

-- Policy 2: Everyone (authenticated or not) can view all active countries  
CREATE POLICY "Public read access to active countries"
  ON countries FOR SELECT
  USING (is_active = true);

-- Policy 3: Super admins can manage countries (via service role)
CREATE POLICY "Service role can manage countries"
  ON countries FOR ALL
  USING (auth.role() = 'service_role');

-- ══════════════════════════════════════════════════════════════════════════════
-- Ensure table has correct structure
-- ══════════════════════════════════════════════════════════════════════════════

-- Verify is_supported column has correct data
UPDATE countries SET is_supported = true WHERE is_supported IS NULL;
UPDATE countries SET is_active = true WHERE is_active IS NULL;

-- ══════════════════════════════════════════════════════════════════════════════
-- Verify data exists
-- ══════════════════════════════════════════════════════════════════════════════

-- This query should return at least the core countries
-- SELECT COUNT(*) as total, COUNT(CASE WHEN is_supported THEN 1 END) as supported
-- FROM countries;
-- Create user_approvals table
-- جدول طلبات موافقة المستخدمين
create table if not exists public.user_approvals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null,
  role text not null,
  registration_type text not null check (registration_type in ('email', 'google', 'facebook')),
  status text not null check (status in ('pending', 'approved', 'rejected')) default 'pending',
  created_at timestamptz default now(),
  approved_at timestamptz,
  rejected_at timestamptz,
  approval_notes text,
  rejection_reason text,
  unique(user_id)
);

-- Enable RLS
alter table public.user_approvals enable row level security;

-- Create indexes
create index if not exists idx_user_approvals_user_id on public.user_approvals(user_id);
create index if not exists idx_user_approvals_status on public.user_approvals(status);
create index if not exists idx_user_approvals_created_at on public.user_approvals(created_at desc);

-- RLS Policies

-- Policy 1: Users can read their own approval record
create policy "Users can read own approval"
  on public.user_approvals
  for select
  using (auth.uid() = user_id);

-- Policy 2: Super admins can read all records
create policy "Super admin can read all approvals"
  on public.user_approvals
  for select
  using (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'super_admin'
  );

-- Policy 3: Super admins can update records
create policy "Super admin can update approval status"
  on public.user_approvals
  for update
  using (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'super_admin'
  )
  with check (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'super_admin'
  );

-- Policy 4: Clinic admins can read approvals for their clinic (if clinic_id is available)
create policy "Clinic admin can read pending approvals"
  on public.user_approvals
  for select
  using (
    (select raw_user_meta_data->>'role' from auth.users where id = auth.uid()) = 'clinic_admin'
    and status = 'pending'
  );

-- Policy 5: System can insert on signup
create policy "Enable insert on user approvals for authenticated users"
  on public.user_approvals
  for insert
  with check (true);

-- Grant permissions
grant select on public.user_approvals to authenticated;
grant select, update on public.user_approvals to authenticated;
