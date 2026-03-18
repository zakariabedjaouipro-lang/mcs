-- Migration: Create Prescription Items Table
-- Purpose: Store individual medication items in prescriptions
-- Version: v2_P04_003
-- Created: 2026-03-04
-- Dependencies: 20260304120012_create_prescriptions_table.sql

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

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