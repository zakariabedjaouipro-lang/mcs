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