-- Create specialties table
CREATE TABLE IF NOT EXISTS specialties (
    id TEXT PRIMARY KEY,
    name_en TEXT NOT NULL,
    name_ar TEXT NOT NULL,
    description_en TEXT,
    description_ar TEXT,
    icon_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default specialties
INSERT INTO specialties (id, name_en, name_ar, description_en, description_ar, icon_name) VALUES
('cardiology', 'Cardiology', 'أمراض القلب', 'Medical specialty focusing on the diagnosis and treatment of heart diseases', 'cardiology'),
('dermatology', 'Dermatology', 'الأمراض الجلد', 'Medical specialty dealing with skin, hair, nails, and mucous membranes', 'dermatology'),
('neurology', 'Neurology', 'الأعصاب', 'Medical specialty dealing with disorders of the nervous system', 'neurology'),
('oncology', 'Oncology', 'الأورام', 'Medical specialty dealing with cancer treatment', 'oncology'),
('pediatrics', 'Pediatrics', 'طب الأطفال', 'Medical specialty dealing with medical care of infants, children, and adolescents', 'pediatrics'),
('psychiatry', 'Psychiatry', 'الطب النفسي', 'Medical specialty dealing with mental health and behavioral disorders', 'psychiatry'),
('orthopedics', 'Orthopedics', 'العظام العظمي', 'Medical specialty focusing on the musculoskeletal system', 'orthopedics'),
('ophthalmology', 'Ophthalmology', 'طب العيون', 'Medical specialty dealing with eye diseases and surgeries', 'ophthalmology'),
('otolaryngology', 'Otolaryngology', 'الأذن والأذن والأذن والأنف والأذن', 'Medical specialty dealing with ear, nose, and throat conditions', 'otolaryngology'),
('general_practice', 'General Practice', 'الطب العام', 'Medical specialty treating common health issues', 'medical_services'),
('family_medicine', 'Family Medicine', 'الطب العائلي', 'Medical specialty providing comprehensive healthcare for individuals and families', 'family_medicine'),
('emergency_medicine', 'Emergency Medicine', 'طب الطوارئ', 'Medical specialty focusing on immediate medical needs and critical care', 'emergency_medicine'),
('radiology', 'Radiology', 'الأشعة', 'Medical specialty using medical imaging to diagnose and treat diseases', 'radiology'),
'anesthesiology', 'Anesthesiology', 'التخدير', 'Medical specialty focusing on anesthesia and perioperative care', 'anesthesiology'),
('plastic_surgery', 'Plastic Surgery', 'الجراحة التجميلية', 'Medical specialty that deals with the repair, reconstruction, or replacement of body parts', 'plastic_surgery'),
 vascular_surgery, 'Vascular Surgery', 'جراحة الأوعية', 'Medical specialty dealing with the circulatory system and vessels', 'vascular_surgery'),
('neurosurgery', 'Neurosurgery', 'جراحة المخ والأعصاب', 'Medical specialty focusing on surgical procedures of the nervous system', 'neurosurgery');

-- Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_specialties_name_en ON specialties(name_en);
CREATE INDEX IF NOT EXISTS idx_specialties_name_ar ON specialties(name_ar);
CREATE INDEX IF NOT EXISTS idx_specialties_icon_name ON specialties(icon_name);

-- Comments
COMMENT ON TABLE specialties IS 'جدول التخصصات الطبية المتاحة';
COMMENT ON COLUMN specialties.name_en IS 'اسم التخصص بالإنجليزي';
COMMENT ON COLUMN specialties.name_ar IS 'اسم التخصص بالعربي';
COMMENT ON COLUMN specialties.description_en IS 'الوصف بالإنجليزي';
COMMENT ON COLUMN specialties.description_ar IS 'الوصف بالعربي';
COMMENT ON COLUMN specialties.icon_name IS 'اسم أيقونة الأيقونة';