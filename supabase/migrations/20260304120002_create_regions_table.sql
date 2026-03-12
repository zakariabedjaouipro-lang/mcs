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