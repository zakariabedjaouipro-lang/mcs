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