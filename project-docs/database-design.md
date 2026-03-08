# تصميم قاعدة البيانات

## معمارية قاعدة البيانات

قاعدة البيانات تعتمد على **PostgreSQL** عبر **Supabase**، مع **Row Level Security (RLS)** لحماية البيانات.

### الخصائص الرئيسية

```
├─ PostgreSQL (٢٧ جدول)
├─ Real-time Subscriptions
├─ Row Level Security (RLS)
├─ Foreign Keys & Constraints
├─ Indexes للأداء
└─ Backup تلقائي
```

---

## الجداول الرئيسية والعلاقات

### 1. جدول `users` (المستخدمون)

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  avatar_url TEXT,
  role user_role NOT NULL DEFAULT 'patient',
  status user_status NOT NULL DEFAULT 'active',
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);
```

### 2. جدول `patients` (المرضى)

```sql
CREATE TABLE patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  date_of_birth DATE,
  gender gender_enum,
  blood_type blood_type_enum,
  allergies TEXT[],
  chronic_diseases TEXT[],
  emergency_contact VARCHAR(255),
  emergency_phone VARCHAR(20),
  clinic_id UUID REFERENCES clinics(id),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_patients_user_id ON patients(user_id);
CREATE INDEX idx_patients_clinic_id ON patients(clinic_id);
```

### 3. جدول `doctors` (الأطباء)

```sql
CREATE TABLE doctors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  license_number VARCHAR(100) NOT NULL UNIQUE,
  specialty_id UUID NOT NULL REFERENCES specialties(id),
  clinic_id UUID NOT NULL REFERENCES clinics(id),
  experience_years INT,
  qualification TEXT[],
  consultation_fee DECIMAL(10, 2),
  rating DECIMAL(3, 2) DEFAULT 0,
  total_consultations INT DEFAULT 0,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_doctors_user_id ON doctors(user_id);
CREATE INDEX idx_doctors_specialty_id ON doctors(specialty_id);
CREATE INDEX idx_doctors_clinic_id ON doctors(clinic_id);
CREATE INDEX idx_doctors_license ON doctors(license_number);
```

### 4. جدول `appointments` (المواعيد)

```sql
CREATE TABLE appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  doctor_id UUID NOT NULL REFERENCES doctors(id),
  patient_id UUID NOT NULL REFERENCES patients(id),
  clinic_id UUID NOT NULL REFERENCES clinics(id),
  
  appointment_date TIMESTAMP NOT NULL,
  duration_minutes INT DEFAULT 30,
  status appointment_status NOT NULL DEFAULT 'scheduled',
  
  reason_for_visit TEXT,
  notes TEXT,
  
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_clinic_id ON appointments(clinic_id);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
```

### 5. جدول `prescriptions` (الوصفات)

```sql
CREATE TABLE prescriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  appointment_id UUID NOT NULL REFERENCES appointments(id),
  doctor_id UUID NOT NULL REFERENCES doctors(id),
  patient_id UUID NOT NULL REFERENCES patients(id),
  
  prescribed_date DATE NOT NULL DEFAULT CURRENT_DATE,
  expiry_date DATE,
  
  notes TEXT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_prescriptions_appointment ON prescriptions(appointment_id);
CREATE INDEX idx_prescriptions_doctor ON prescriptions(doctor_id);
CREATE INDEX idx_prescriptions_patient ON prescriptions(patient_id);
```

### 6. جدول `prescription_items` (بنود الوصفة)

```sql
CREATE TABLE prescription_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
  
  medication_name VARCHAR(255) NOT NULL,
  dosage VARCHAR(100),
  frequency VARCHAR(100),
  quantity INT,
  unit VARCHAR(50),
  duration_days INT,
  
  created_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_prescription_items_prescription ON prescription_items(prescription_id);
```

### 7. جدول `clinics` (العيادات)

```sql
CREATE TABLE clinics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  phone VARCHAR(20),
  email VARCHAR(255),
  
  address TEXT,
  city VARCHAR(100),
  country VARCHAR(100),
  
  license_number VARCHAR(100),
  established_date DATE,
  
  logo_url TEXT,
  website VARCHAR(255),
  
  subscription_id UUID REFERENCES subscriptions(id),
  status clinic_status DEFAULT 'active',
  
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_clinics_subscription ON clinics(subscription_id);
CREATE INDEX idx_clinics_status ON clinics(status);
```

### 8. جدول `subscriptions` (الاشتراكات)

```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id UUID NOT NULL REFERENCES clinics(id),
  
  plan_type subscription_type NOT NULL,
  
  start_date DATE NOT NULL DEFAULT CURRENT_DATE,
  end_date DATE NOT NULL,
  
  max_doctors INT,
  max_patients INT,
  max_appointments INT,
  
  price DECIMAL(10, 2),
  currency VARCHAR(3) DEFAULT 'SAR',
  
  status subscription_status DEFAULT 'active',
  
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_subscriptions_clinic ON subscriptions(clinic_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_dates ON subscriptions(start_date, end_date);
```

### 9. جدول `invoices` (الفواتير)

```sql
CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number VARCHAR(50) NOT NULL UNIQUE,
  
  clinic_id UUID NOT NULL REFERENCES clinics(id),
  patient_id UUID REFERENCES patients(id),
  
  appointment_id UUID REFERENCES appointments(id),
  
  total_amount DECIMAL(10, 2),
  tax_amount DECIMAL(10, 2),
  currency VARCHAR(3) DEFAULT 'SAR',
  
  status payment_status NOT NULL DEFAULT 'pending',
  payment_method VARCHAR(50),
  
  issue_date TIMESTAMP DEFAULT now(),
  due_date DATE,
  paid_date TIMESTAMP,
  
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_invoices_clinic ON invoices(clinic_id);
CREATE INDEX idx_invoices_patient ON invoices(patient_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_number ON invoices(invoice_number);
```

### 10. جدول `inventory` (المخزون)

```sql
CREATE TABLE inventory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id UUID NOT NULL REFERENCES clinics(id),
  
  item_name VARCHAR(255) NOT NULL,
  item_type inventory_type NOT NULL,
  
  quantity_on_hand INT NOT NULL DEFAULT 0,
  quantity_reserved INT DEFAULT 0,
  reorder_level INT,
  reorder_quantity INT,
  
  unit_price DECIMAL(10, 2),
  supplier VARCHAR(255),
  
  batch_number VARCHAR(100),
  expiry_date DATE,
  
  status inventory_status DEFAULT 'active',
  last_updated TIMESTAMP DEFAULT now(),
  
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Indexes
CREATE INDEX idx_inventory_clinic ON inventory(clinic_id);
CREATE INDEX idx_inventory_type ON inventory(item_type);
CREATE INDEX idx_inventory_status ON inventory(status);
```

---

## الأنواع المخصصة (Enums)

```sql
-- User Role
CREATE TYPE user_role AS ENUM (
  'patient',
  'doctor',
  'employee',
  'admin',
  'super_admin'
);

-- User Status
CREATE TYPE user_status AS ENUM (
  'active',
  'inactive',
  'suspended',
  'deleted'
);

-- Gender
CREATE TYPE gender_enum AS ENUM ('male', 'female', 'other');

-- Blood Type
CREATE TYPE blood_type_enum AS ENUM (
  'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'
);

-- Appointment Status
CREATE TYPE appointment_status AS ENUM (
  'scheduled',
  'confirmed',
  'in_progress',
  'completed',
  'cancelled',
  'no_show'
);

-- Payment Status
CREATE TYPE payment_status AS ENUM (
  'pending',
  'paid',
  'partially_paid',
  'overdue',
  'refunded'
);

-- Subscription Type
CREATE TYPE subscription_type AS ENUM (
  'starter',
  'professional',
  'enterprise'
);

-- Subscription Status
CREATE TYPE subscription_status AS ENUM (
  'active',
  'inactive',
  'expired',
  'cancelled'
);

-- Clinic Status
CREATE TYPE clinic_status AS ENUM (
  'active',
  'inactive',
  'suspended'
);

-- Inventory Type
CREATE TYPE inventory_type AS ENUM (
  'medicine',
  'medical_equipment',
  'supplies',
  'other'
);

-- Inventory Status
CREATE TYPE inventory_status AS ENUM (
  'active',
  'discontinued',
  'out_of_stock'
);
```

---

## سياسات الأمان (RLS - Row Level Security)

### سياسات المريض

```sql
-- المريض يرى فقط بياناته
CREATE POLICY patient_read_own
  ON patients FOR SELECT
  USING (auth.uid() = user_id);

-- المريض يعدل فقط بيانته
CREATE POLICY patient_update_own
  ON patients FOR UPDATE
  USING (auth.uid() = user_id);

-- المريض يرى مواعيده فقط
CREATE POLICY patient_read_own_appointments
  ON appointments FOR SELECT
  USING (patient_id = (SELECT id FROM patients WHERE user_id = auth.uid()));
```

### سياسات الطبيب

```sql
-- الطبيب يرى فقط بيانات مرضاه
CREATE POLICY doctor_read_own_appointments
  ON appointments FOR SELECT
  USING (
    doctor_id = (SELECT id FROM doctors WHERE user_id = auth.uid())
  );

-- الطبيب يقدر يكتب وصفات للمواعيد متاعه
CREATE POLICY doctor_create_prescriptions
  ON prescriptions FOR INSERT
  WITH CHECK (
    doctor_id = (SELECT id FROM doctors WHERE user_id = auth.uid())
  );
```

### سياسات المدير

```sql
-- مدير العيادة يرى كل البيانات متاعة عيادته
CREATE POLICY clinic_admin_read
  ON appointments FOR SELECT
  USING (
    clinic_id IN (
      SELECT id FROM clinics 
      WHERE owner_id = auth.uid()
    )
  );
```

---

## المؤشرات (Indexes)

### مؤشرات الأداء الأساسية

```sql
-- Frequently searched fields
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_doctors_clinic ON doctors(clinic_id);
CREATE INDEX idx_patients_clinic ON patients(clinic_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);

-- Foreign keys
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);

-- Status searches
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);

-- Composite indexes
CREATE INDEX idx_appointments_doctor_date 
  ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_invoices_clinic_patient 
  ON invoices(clinic_id, patient_id);
```

---

## النسخ الاحتياطية والاسترجاع

### استراتيجية النسخ الاحتياطية

```
┌─────────────────────────────────────┐
│     Backup Strategy                 │
├─────────────────────────────────────┤
│ ✓ Daily Full Backups                │
│ ✓ Hourly Incremental Backups        │
│ ✓ Point-in-time Recovery (PITR)    │
│ ✓ Geographic Redundancy             │
│ ✓ Retention: 30 days minimum        │
└─────────────────────────────────────┘
```

---

## تحسينات الأداء

### استراتيجيات التحسين

| الاستراتيجية | الوصف | التأثير |
|-------------|--------|---------|
| **Indexing** | إنشء مؤشرات على الحقول المبحوث عنها | +40% أداء |
| **Partitioning** | تقسيم الجداول الكبيرة | +30% |
| **Caching** | تخزين النتائج المتكررة | +60% |
| **Query Optimization** | تحسين الاستعلامات | +25% |

### تعقيد الاستعلام

```sql
-- ✅ استعلام فعال
SELECT a.id, a.appointment_date, d.name
FROM appointments a
JOIN doctors d ON a.doctor_id = d.id
WHERE a.doctor_id = $1
  AND a.appointment_date > CURRENT_DATE
  AND a.status = 'scheduled'
ORDER BY a.appointment_date
LIMIT 10;

-- ❌ استعلام غير فعال
SELECT *
FROM appointments
WHERE EXTRACT(YEAR FROM appointment_date) = 2026
  AND status LIKE '%scheduled%';
```

---

## migrations والإصدارات

### نظام Migrations

```
supabase/migrations/
├── 01_create_initial_schema.sql
├── 02_add_rls_policies.sql
├── 03_add_indexes.sql
├── 04_add_new_fields.sql
└── 05_add_triggers.sql
```

### تطبيق Migrations

```bash
# تطبيق جميع Migrations
supabase db push

# إرجاع Migration
supabase db reset

# عرض حالة Migrations
supabase migration list
```

---

## العلاقات والقيود

### الفئات 1:N

```
Users (1) ──→ (N) Patients
Users (1) ──→ (N) Doctors
Doctors (1) ──→ (N) Appointments
Patients (1) ──→ (N) Appointments
Appointments (1) ──→ (N) Prescriptions
```

### الفئات M:N

```
Doctors (M) ──→ (N) Specialties
Doctors (M) ──→ (N) Clinics
Patients (M) ──→ (N) Clinics (عبر جدول وسيط)
```

---

## مثال على استعلام بسيط

### الحصول على مواعيد المريض

```dart
Future<List<Appointment>> getPatientAppointments(String patientId) async {
  final response = await supabase
    .from('appointments')
    .select('''
      id,
      appointment_date,
      status,
      doctor:doctor_id (id, name, specialty:specialty_id (name)),
      clinic:clinic_id (name, address)
    ''')
    .eq('patient_id', patientId)
    .gte('appointment_date', DateTime.now().toIso8601String())
    .order('appointment_date', ascending: true)
    .limit(10);
    
  return response
    .map((json) => Appointment.fromJson(json))
    .toList();
}
```

---

## قائمة التحقق لقاعدة البيانات

- [ ] جميع الجداول مع PKs و FKs
- [ ] Indexes على الحقول المبحوث عنها
- [ ] RLS Policies مفعلة
- [ ] Constraints و Validations
- [ ] Migrations مختبرة
- [ ] Backup strategy محددة
- [ ] Performance tested
- [ ] Data types صحيحة

