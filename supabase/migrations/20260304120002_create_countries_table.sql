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
('Yemen', 'اليمن', 'YE', 'YEM', 887, '+967', 'YER', 'Yemeni Rial', 'ريال يمني', 'ر.ي', 'Asia', 'Asia', 'Western Asia', "Sana'a", 'صنعاء'),
('Oman', 'عمان', 'OM', 'OMN', 512, '+968', 'OMR', 'Omani Rial', 'ريال عماني', 'ر.ع', 'Asia', 'Asia', 'Western Asia', 'Muscat', 'مسقط'),
('Bahrain', 'البحرين', 'BH', 'BHR', 48, '+973', 'BHD', 'Bahraini Dinar', 'دينار بحريني', 'د.ب', 'Asia', 'Asia', 'Western Asia', 'Manama', 'المنامة'),
('Palestin', 'قلسطين', 'IL', 'ISR', 376, '+972', 'ILS', 'Palestiny New Shekel', 'شيكل فلسطيني جديد', '₪', 'Asia', 'Asia', 'Western Asia', 'Jerusalem', 'القدس'),
('Palestine', 'فلسطين', 'PS', 'PSE', 275, '+970', 'ILS', 'Palestini New Shekel', 'شيكل فلسطيني جديد', '₪', 'Asia', 'Asia', 'Western Asia', 'Ramallah', 'رام الله')
ON CONFLICT (iso2_code) DO NOTHING;