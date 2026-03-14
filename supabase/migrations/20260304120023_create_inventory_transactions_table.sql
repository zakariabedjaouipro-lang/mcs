-- Migration: Create Inventory Transactions Table
-- Purpose: Track inventory stock movements
-- Version: v2_P05_004
-- Created: 2026-03-04
-- Dependencies: 20260304120016_create_inventory_table.sql

-- Create auth schema for Supabase compatibility
CREATE SCHEMA IF NOT EXISTS auth;

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory Transactions Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create inventory_transactions table to track inventory stock movements
CREATE TABLE IF NOT EXISTS inventory_transactions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  inventory_item_id UUID NOT NULL REFERENCES inventory(id) ON DELETE CASCADE,
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
  related_invoice_item_id UUID REFERENCES invoice_items(id) ON DELETE SET NULL,
  related_prescription_item_id UUID REFERENCES prescription_items(id) ON DELETE SET NULL,

  -- Transaction Information
  transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'return', 'adjustment', 'transfer', 'expiry', 'damage', 'loss')),
  
  -- Quantity Changes
  quantity_before DECIMAL(10, 2) NOT NULL,
  quantity_change DECIMAL(10, 2) NOT NULL,
  quantity_after DECIMAL(10, 2) NOT NULL,
  
  -- Cost and Value
  unit_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  total_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  currency VARCHAR(3) DEFAULT 'USD',
  
  -- Batch Information
  batch_number VARCHAR(50),
  lot_number VARCHAR(50),
  serial_number VARCHAR(100),
  expiry_date DATE,
  manufacturing_date DATE,
  
  -- Supplier Information
  supplier_id UUID,
  supplier_name VARCHAR(255),
  supplier_contact VARCHAR(255),
  
  -- Transfer Information (for transfer transactions)
  from_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  to_clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  transfer_reference VARCHAR(100),
  
  -- Reason and Notes
  reason VARCHAR(255),
  notes TEXT,
  notes_ar TEXT,
  
  -- Reference Information
  reference_number VARCHAR(100),
  reference_type VARCHAR(50), -- PO, SO, ADJUSTMENT, etc.
  
  -- Approval
  requires_approval BOOLEAN DEFAULT false,
  approved_by UUID REFERENCES users(id) ON DELETE SET NULL,
  approved_at TIMESTAMP WITH TIME ZONE,
  approval_notes TEXT,
  
  -- System Fields
  transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_quantity_change CHECK (quantity_change != 0),
  CONSTRAINT valid_quantity_after CHECK (quantity_after >= 0),
  CONSTRAINT valid_unit_cost CHECK (unit_cost >= 0),
  CONSTRAINT valid_total_cost CHECK (total_cost >= 0)
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ══════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_inventory_transactions_inventory_item_id ON inventory_transactions(inventory_item_id);
CREATE INDEX idx_inventory_transactions_clinic_id ON inventory_transactions(clinic_id);
CREATE INDEX idx_inventory_transactions_related_invoice_item_id ON inventory_transactions(related_invoice_item_id);
CREATE INDEX idx_inventory_transactions_related_prescription_item_id ON inventory_transactions(related_prescription_item_id);
CREATE INDEX idx_inventory_transactions_transaction_type ON inventory_transactions(transaction_type);
CREATE INDEX idx_inventory_transactions_batch_number ON inventory_transactions(batch_number);
CREATE INDEX idx_inventory_transactions_expiry_date ON inventory_transactions(expiry_date);
CREATE INDEX idx_inventory_transactions_supplier_id ON inventory_transactions(supplier_id);
CREATE INDEX idx_inventory_transactions_from_clinic_id ON inventory_transactions(from_clinic_id);
CREATE INDEX idx_inventory_transactions_to_clinic_id ON inventory_transactions(to_clinic_id);
CREATE INDEX idx_inventory_transactions_reference_number ON inventory_transactions(reference_number);
CREATE INDEX idx_inventory_transactions_transaction_date ON inventory_transactions(transaction_date DESC);
CREATE INDEX idx_inventory_transactions_created_by ON inventory_transactions(created_by);
CREATE INDEX idx_inventory_transactions_approved_by ON inventory_transactions(approved_by);

-- ══════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ══════════════════════════════════════════════════════════════════════════════

-- Enable RLS on inventory_transactions table
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;

-- Policy: Clinic staff can view clinic inventory transactions
CREATE POLICY "Clinic staff can view clinic inventory transactions"
  ON inventory_transactions FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can create inventory transactions
CREATE POLICY "Clinic staff can create inventory transactions"
  ON inventory_transactions FOR INSERT
  WITH CHECK (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff WHERE user_id = auth.uid()
      AND role IN ('admin', 'manager', 'technician', 'nurse')
    )
  );

-- Policy: Super admins can manage all inventory transactions
CREATE POLICY "Super admins can manage all inventory transactions"
  ON inventory_transactions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE inventory_transactions IS 'Inventory stock movements tracking';
COMMENT ON COLUMN inventory_transactions.id IS 'Primary key (UUID)';
COMMENT ON COLUMN inventory_transactions.inventory_item_id IS 'Reference to inventory item';
COMMENT ON COLUMN inventory_transactions.clinic_id IS 'Reference to clinic';
COMMENT ON COLUMN inventory_transactions.transaction_type IS 'Type of transaction (purchase, sale, return, etc.)';
COMMENT ON COLUMN inventory_transactions.quantity_before IS 'Quantity before transaction';
COMMENT ON COLUMN inventory_transactions.quantity_change IS 'Quantity change (positive for additions, negative for deductions)';
COMMENT ON COLUMN inventory_transactions.quantity_after IS 'Quantity after transaction';
COMMENT ON COLUMN inventory_transactions.unit_cost IS 'Cost per unit';
COMMENT ON COLUMN inventory_transactions.total_cost IS 'Total cost';
COMMENT ON COLUMN inventory_transactions.batch_number IS 'Batch number';
COMMENT ON COLUMN inventory_transactions.expiry_date IS 'Expiry date';
COMMENT ON COLUMN inventory_transactions.supplier_name IS 'Supplier name';
COMMENT ON COLUMN inventory_transactions.transaction_date IS 'Date of transaction';
COMMENT ON COLUMN inventory_transactions.created_by IS 'User who created the transaction';