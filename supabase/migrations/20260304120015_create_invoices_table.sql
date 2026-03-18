-- Migration: Create Invoices Table
-- Purpose: Store invoice information for services rendered
-- Version: v2_P05_001
-- Created: 2026-03-04
-- Dependencies: v2_P03_001_create_doctors_table.sql, v2_P03_002_create_patients_table.sql, v2_P04_001_create_appointments_table.sql, v2_P02_002_create_clinics_table.sql

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

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