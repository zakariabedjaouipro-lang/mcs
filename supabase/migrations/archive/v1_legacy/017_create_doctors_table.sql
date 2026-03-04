-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
    id TEXT PRIMARY KEY,
    user_id TEXT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    clinic_id TEXT REFERENCES clinics(id) ON DELETE SET NULL,
    specialty_id TEXT REFERENCES specialties(id) ON DELETE SET NULL,
    license_number TEXT UNIQUE,
    national_id TEXT,
    date_of_birth DATE,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    phone TEXT,
    email TEXT,
    education TEXT,
    experience_years INT DEFAULT 0,
    bio TEXT,
    consultation_fee NUMERIC DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    rating NUMERIC CHECK (rating >= 0 AND rating <= 5),
    total_ratings INT DEFAULT 0,
    profile_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_doctors_user_id ON doctors(user_id);
CREATE INDEX IF NOT EXISTS idx_doctors_clinic_id ON doctors(clinic_id);
CREATE INDEX IF NOT EXISTS idx_doctors_specialty_id ON doctors(specialty_id);
CREATE INDEX IF NOT EXISTS idx_doctors_is_available ON doctors(is_available);
CREATE INDEX IF NOT EXISTS idx_doctors_is_active ON doctors(is_active);
CREATE INDEX IF NOT EXISTS idx_doctors_rating ON doctors(rating);

-- Comments
COMMENT ON TABLE doctors IS 'جدول الأطباء في النظام';
COMMENT ON COLUMN doctors.user_id IS 'معرف المستخدم';
COMMENT ON COLUMN doctors.clinic_id IS 'معرف العيادة';
COMMENT ON COLUMN doctors.specialty_id IS 'معرف التخصص';
COMMENT ON COLUMN doctors.license_number IS 'رقم الترخيص';
COMMENT ON doctors.consultation_fee IS 'رسوم الاستشارة';
COMMENT ON doctors.rating IS 'التقييم';
COMMENT ON doctors.is_available IS 'متاح للحجوز';
COMMENT ON doctors.is_active IS 'نشط';