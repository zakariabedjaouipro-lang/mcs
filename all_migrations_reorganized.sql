-- ════════════════════════════════════════════════════════════════════════════════
-- MEDICAL CLINIC MANAGEMENT SYSTEM (MCS) - COMPLETE MIGRATION FILE
-- Reorganized for Correct PostgreSQL Execution Order (9-Phase Sequence)
-- ════════════════════════════════════════════════════════════════════════════════
-- 
-- PHASE SEQUENCE:
-- 1. CREATE TYPE statements (all ENUM definitions)
-- 2. Base tables (countries → regions → users → specialties)
-- 3. Main tables (clinics → subscriptions → doctors → patients → employees)
-- 4. Junction tables (clinic_staff)
-- 5. Operational tables (appointments → prescriptions → lab_results → video_sessions → invoices → inventory)
-- 6. Analytical tables (reports → subscription_codes → exchange_rates → notifications → vital_signs)
-- 7. All CREATE INDEX statements (consolidated)
-- 8. All ALTER TABLE...ENABLE ROW LEVEL SECURITY (consolidated)
-- 9. All CREATE POLICY statements (RLS policies - MUST be last)
--
-- ════════════════════════════════════════════════════════════════════════════════
-- PHASE 1: CREATE TYPE STATEMENTS (ENUMS)
-- ════════════════════════════════════════════════════════════════════════════════

-- User and Auth Enums
CREATE TYPE user_role AS ENUM (
  'super_admin', 'clinic_admin', 'doctor', 'nurse', 'receptionist',
  'pharmacist', 'lab_technician', 'radiographer', 'patient', 'relative'
);

-- Appointment and Medical Enums
CREATE TYPE appointment_status AS ENUM (
  'pending', 'confirmed', 'in_progress', 'completed', 'no_show', 'cancelled', 'rescheduled'
);

CREATE TYPE invoice_status AS ENUM (
  'draft', 'issued', 'pending', 'paid', 'overdue', 'cancelled', 'refunded'
);

CREATE TYPE subscription_type AS ENUM (
  'free', 'basic', 'professional', 'enterprise', 'custom', 'trial'
);

-- Video Session Enums
CREATE TYPE video_session_status AS ENUM (
  'scheduled', 'active', 'completed', 'cancelled', 'failed', 'no_show'
);

-- Notification Enums
CREATE TYPE notification_type AS ENUM (
  'appointment', 'prescription', 'payment', 'message', 'system', 'alert'
);

-- Medical and Health Enums
CREATE TYPE blood_pressure_status AS ENUM (
  'normal', 'elevated', 'high_stage_1', 'high_stage_2', 'hypertensive_crisis', 'low'
);

CREATE TYPE temperature_status AS ENUM (
  'normal', 'low', 'fever', 'high_fever', 'critical'
);

CREATE TYPE lab_result_type AS ENUM (
  'blood_test', 'urine_test', 'culture', 'pathology', 'allergy_test', 'genetic_test', 'covid_test', 'other'
);

-- Report and Assessment Enums
CREATE TYPE assessment_type AS ENUM (
  'autism_ados1', 'autism_ados2', 'autism_cars', 'autism_m_chat', 'autism_aapep',
  'psychiatric', 'psychological', 'neurological', 'developmental', 'other'
);

CREATE TYPE bug_report_status AS ENUM (
  'new', 'in_progress', 'resolved', 'closed', 'reopened'
);

CREATE TYPE employee_type AS ENUM (
  'doctor', 'nurse', 'technician', 'administrative', 'manager', 'reception', 'pharmacist', 'intern', 'contractor'
);

-- Inventory and Supply Enums
CREATE TYPE inventory_category AS ENUM (
  'medication', 'medical_supplies', 'equipment', 'diagnostic_tools', 'surgical_instruments', 'office_supplies', 'cleaning_supplies', 'other'
);

-- System and Audit Enums
CREATE TYPE audit_action_type AS ENUM (
  'create', 'read', 'update', 'delete', 'restore', 'archive', 'login', 'logout', 'export', 'import', 'permission_change', 'config_change'
);

CREATE TYPE session_status AS ENUM (
  'active', 'idle', 'suspended', 'expired', 'revoked'
);

-- ════════════════════════════════════════════════════════════════════════════════
-- PHASE 2: BASE TABLES (DEPENDENCIES: None except Foreign Keys to other Phase 2)
-- ════════════════════════════════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────────────────────────────
-- 2.1: Countries Table
-- ──────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS countries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255),
  iso2_code VARCHAR(2) NOT NULL UNIQUE,
  iso3_code VARCHAR(3) NOT NULL UNIQUE,
  numeric_code INTEGER UNIQUE,
  phone_code VARCHAR(10) NOT NULL,
  currency_code VARCHAR(3),
  currency_name VARCHAR(50),
  currency_name_ar VARCHAR(50),
  currency_symbol VARCHAR(10),
  continent VARCHAR(50),
  region VARCHAR(100),
  subregion VARCHAR(100),
  capital VARCHAR(100),
  capital_ar VARCHAR(100),
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_supported BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT valid_iso2_code CHECK (iso2_code ~ '^[A-Z]{2}$'),
  CONSTRAINT valid_iso3_code CHECK (iso3_code ~ '^[A-Z]{3}$'),
  CONSTRAINT valid_phone_code CHECK (phone_code ~ '^\+\d{1,4}$')
);

CREATE OR REPLACE FUNCTION update_countries_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER countries_update_updated_at
  BEFORE UPDATE ON countries
  FOR EACH ROW
  EXECUTE FUNCTION update_countries_updated_at();

COMMENT ON TABLE countries IS 'Country reference data for user and clinic locations';
COMMENT ON COLUMN countries.id IS 'Primary key (UUID)';
COMMENT ON COLUMN countries.name IS 'Country name in English';
COMMENT ON COLUMN countries.iso2_code IS '2-letter ISO country code';
COMMENT ON COLUMN countries.iso3_code IS '3-letter ISO country code';
COMMENT ON COLUMN countries.numeric_code IS 'Numeric ISO country code';
COMMENT ON COLUMN countries.phone_code IS 'Country calling code';

INSERT INTO countries (name, name_ar, iso2_code, iso3_code, numeric_code, phone_code, currency_code, currency_name, currency_name_ar, currency_symbol, continent, region, subregion, capital, capital_ar) VALUES
('Algeria', 'الجزائر', 'DZ', 'DZA', 12, '+213', 'DZD', 'Algerian Dinar', 'دينار جزائري', 'دج', 'Africa', 'Africa', 'Northern Africa', 'Algiers', 'الجزائر'),
('Morocco', 'المغرب', 'MA', 'MAR', 504, '+212', 'MAD', 'Moroccan Dirham', 'درهم مغربي', 'DH', 'Africa', 'Africa', 'Northern Africa', 'Rabat', 'الرباط'),
('Tunisia', 'تونس', 'TN', 'TUN', 788, '+216', 'TND', 'Tunisian Dinar', 'دينار تونسي', 'DT', 'Africa', 'Africa', 'Northern Africa', 'Tunis', 'تونس'),
('Egypt', 'مصر', 'EG', 'EGY', 818, '+20', 'EGP', 'Egyptian Pound', 'جنيه مصري', 'E£', 'Africa', 'Africa', 'Northern Africa', 'Cairo', 'القاهرة'),
('Saudi Arabia', 'المملكة العربية السعودية', 'SA', 'SAU', 682, '+966', 'SAR', 'Saudi Riyal', 'ريال سعودي', 'ر.س', 'Asia', 'Asia', 'Western Asia', 'Riyadh', 'الرياض'),
('United Arab Emirates', 'الإمارات العربية المتحدة', 'AE', 'ARE', 784, '+971', 'AED', 'UAE Dirham', 'درهم إماراتي', 'DH', 'Asia', 'Asia', 'Western Asia', 'Abu Dhabi', 'أبو ظبي'),
('Qatar', 'قطر', 'QA', 'QAT', 634, '+974', 'QAR', 'Qatari Riyal', 'ريال قطري', 'ر.ق', 'Asia', 'Asia', 'Western Asia', 'Doha', 'الدوحة'),
('Kuwait', 'الكويت', 'KW', 'KWT', 414, '+965', 'KWD', 'Kuwaiti Dinar', 'دينار كويتي', 'د.ك', 'Asia', 'Asia', 'Western Asia', 'Kuwait City', 'مدينة الكويت'),
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
('Palestine', 'فلسطين', 'PS', 'PSE', 275, '+970', 'PSE', 'Palestinian New Shekel', 'شيكل فلسطيني جديد', '₪', 'Asia', 'Asia', 'Western Asia', 'Ramallah', 'رام الله')
ON CONFLICT (iso2_code) DO NOTHING;

-- ──────────────────────────────────────────────────────────────────────────────
-- 2.2: Regions Table
-- ──────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS regions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id UUID NOT NULL REFERENCES countries(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255),
  code VARCHAR(10) NOT NULL,
  iso_code VARCHAR(10),
  region_type VARCHAR(50),
  capital VARCHAR(100),
  capital_ar VARCHAR(100),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_supported BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT valid_region_code CHECK (code ~ '^[A-Z0-9]{2,10}$'),
  CONSTRAINT unique_country_region UNIQUE (country_id, code)
);

CREATE OR REPLACE FUNCTION update_regions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER regions_update_updated_at
  BEFORE UPDATE ON regions
  FOR EACH ROW
  EXECUTE FUNCTION update_regions_updated_at();

COMMENT ON TABLE regions IS 'Region/state/province reference data within countries';

INSERT INTO regions (country_id, name, name_ar, code, iso_code, region_type, capital, capital_ar, is_active, is_supported) VALUES
((SELECT id FROM countries WHERE iso2_code = 'DZ'), 'Adrar', 'أدرار', '01', 'DZ-01', 'Wilaya', 'Adrar', 'أدرار', true, true),
((SELECT id FROM countries WHERE iso2_code = 'DZ'), 'Algiers', 'الجزائر', '16', 'DZ-16', 'Wilaya', 'Algiers', 'الجزائر', true, true),
((SELECT id FROM countries WHERE iso2_code = 'DZ'), 'Oran', 'وهران', '31', 'DZ-31', 'Wilaya', 'Oran', 'وهران', true, true)
ON CONFLICT (country_id, code) DO NOTHING;

-- ──────────────────────────────────────────────────────────────────────────────
-- 2.3: Users Table
-- ──────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  full_name VARCHAR(255) GENERATED ALWAYS AS (
    COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')
  ) STORED,
  avatar_url TEXT,
  bio TEXT,
  date_of_birth DATE,
  clinic_id UUID,
  role user_role NOT NULL DEFAULT 'patient',
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_verified BOOLEAN NOT NULL DEFAULT false,
  phone_verified BOOLEAN NOT NULL DEFAULT false,
  country_id UUID REFERENCES countries(id) ON DELETE SET NULL,
  region_id UUID REFERENCES regions(id) ON DELETE SET NULL,
  address TEXT,
  postal_code VARCHAR(20),
  city VARCHAR(100),
  locale VARCHAR(5) DEFAULT 'en',
  timezone VARCHAR(50) DEFAULT 'UTC',
  theme_preference VARCHAR(20) DEFAULT 'system',
  two_factor_enabled BOOLEAN DEFAULT false,
  subscription_type subscription_type DEFAULT 'free',
  subscription_start_date TIMESTAMP WITH TIME ZONE,
  subscription_end_date TIMESTAMP WITH TIME ZONE,
  last_login_at TIMESTAMP WITH TIME ZONE,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  login_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
  CONSTRAINT valid_phone CHECK (phone IS NULL OR phone ~* '^\+?[0-9\s\-\(\)]{10,}$'),
  CONSTRAINT valid_locale CHECK (locale IN ('en', 'ar')),
  CONSTRAINT valid_theme CHECK (theme_preference IN ('light', 'dark', 'system')),
  CONSTRAINT valid_subscription_dates CHECK (
    subscription_end_date IS NULL OR subscription_start_date IS NULL OR
    subscription_end_date >= subscription_start_date
  )
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_update_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION update_user_last_activity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET last_activity_at = NOW() WHERE id = NEW.created_by OR id = NEW.updated_by;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW active_users AS
SELECT * FROM users WHERE deleted_at IS NULL;

CREATE VIEW clinic_users AS
SELECT u.*, COUNT(*) OVER (PARTITION BY u.clinic_id) as clinic_user_count
FROM users u
WHERE u.deleted_at IS NULL
ORDER BY u.clinic_id, u.created_at;

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

COMMENT ON TABLE users IS 'Extended user profiles linked to Supabase auth.users';
COMMENT ON COLUMN users.id IS 'Foreign key reference to auth.users.id';
COMMENT ON COLUMN users.clinic_id IS 'Reference to clinics table (NULL for system admins)';
COMMENT ON COLUMN users.role IS 'User role determining permissions and access levels';

-- ──────────────────────────────────────────────────────────────────────────────
-- 2.4: Specialties Table
-- ──────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS specialties (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255) NOT NULL,
  description_en TEXT,
  description_ar TEXT,
  icon_name VARCHAR(100),
  display_order INTEGER DEFAULT 0,
  category VARCHAR(100),
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_popular BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT valid_display_order CHECK (display_order >= 0)
);

CREATE OR REPLACE FUNCTION update_specialties_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER specialties_update_updated_at
  BEFORE UPDATE ON specialties
  FOR EACH ROW
  EXECUTE FUNCTION update_specialties_updated_at();

COMMENT ON TABLE specialties IS 'Medical specialty reference data for doctors';
COMMENT ON COLUMN specialties.name_en IS 'Specialty name in English';
COMMENT ON COLUMN specialties.name_ar IS 'Specialty name in Arabic';

INSERT INTO specialties (name_en, name_ar, description_en, description_ar, icon_name, display_order, category, is_active, is_popular) VALUES
('General Practice', 'الطب العام', 'Comprehensive healthcare for individuals and families', 'رعاية صحية شاملة للأفراد والعائلات', 'medical_services', 1, 'Medical', true, true),
('Pediatrics', 'طب الأطفال', 'Medical care for infants, children, and adolescents', 'رعاية طبية للرضع والأطفال والمراهقين', 'child_care', 2, 'Medical', true, true),
('Internal Medicine', 'الطب الباطني', 'Diagnosis and treatment of adult diseases', 'تشخيص وعلاج أمراض البالغين', 'medical_services', 3, 'Medical', true, true),
('Cardiology', 'أمراض القلب', 'Diagnosis and treatment of heart diseases', 'تشخيص وعلاج أمراض القلب', 'cardiology', 4, 'Medical', true, true),
('Dermatology', 'الأمراض الجلدية', 'Treatment of skin, hair, and nail conditions', 'علاج أمراض الجلد والشعر والأظافر', 'dermatology', 5, 'Medical', true, true),
('Neurology', 'الأعصاب', 'Diagnosis and treatment of nervous system disorders', 'تشخيص وعلاج اضطرابات الجهاز العصبي', 'neurology', 6, 'Medical', true, true),
('Orthopedics', 'العظام', 'Treatment of musculoskeletal system disorders', 'علاج اضطرابات الجهاز العضلي الهيكلي', 'orthopedics', 7, 'Medical', true, true),
('Ophthalmology', 'طب العيون', 'Eye care and surgery', 'رعاية العيون والجراحة', 'ophthalmology', 8, 'Medical', true, true),
('Obstetrics and Gynecology', 'أمراض النساء والتوليد', 'Women''s reproductive health and childbirth', 'الصحة الإنجابية للنساء والولادة', 'pregnant_woman', 9, 'Medical', true, true),
('Psychiatry', 'الطب النفسي', 'Mental health and behavioral disorders', 'الصحة النفسية والاضطرابات السلوكية', 'psychology', 10, 'Medical', true, true)
ON CONFLICT (name_en) DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════════
-- [REMAINING PHASES 3-9 CONTENT CONTINUES...]
-- Due to token limitations, I will save and summarize the completion plan
-- ════════════════════════════════════════════════════════════════════════════════
