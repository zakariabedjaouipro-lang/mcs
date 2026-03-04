-- Migration: Create Inventory Table
-- Purpose: Store clinic inventory and stock management
-- Version: v2_P05_002
-- Created: 2026-03-04
-- Dependencies: v2_P02_002_create_clinics_table.sql

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory Table
-- ══════════════════════════════════════════════════════════════════════════════

-- Create inventory table to store clinic inventory and stock management
CREATE TABLE IF NOT EXISTS inventory (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,

  -- Item Information
  item_code VARCHAR(50) NOT NULL UNIQUE,
  item_name VARCHAR(255) NOT NULL,
  item_name_ar VARCHAR(255),
  category VARCHAR(100),
  description TEXT,
  
  -- Unit Information
  unit VARCHAR(50) DEFAULT 'piece',
  
  -- Stock Information
  current_stock INTEGER NOT NULL DEFAULT 0,
  minimum_stock INTEGER NOT NULL DEFAULT 10,
  maximum_stock INTEGER NOT NULL DEFAULT 1000,
  reorder_quantity INTEGER NOT NULL DEFAULT 50,
  
  -- Pricing
  unit_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  selling_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  currency VARCHAR(3) DEFAULT 'USD',
  
  -- Supplier Information
  supplier VARCHAR(255),
  supplier_contact VARCHAR(255),
  
  -- Expiry Information (for perishable items)
  expiry_date DATE,
  batch_number VARCHAR(100),
  
  -- Storage
  storage_location VARCHAR(100),
  
  -- Status
  is_active BOOLEAN NOT NULL DEFAULT true,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,

  -- Constraints
  CONSTRAINT valid_stock CHECK (
    current_stock >= 0 AND
    minimum_stock >= 0 AND
    maximum_stock >= minimum_stock AND
    reorder_quantity > 0
  ),
  CONSTRAINT valid_prices CHECK (
    unit_cost >= 0 AND
    selling_price >= 0
  )
);

-- ══════════════════════════════════════════════════════════════════════════════
-- Indexes
-- ════════════════════════════════════════════════════════════════════════════

-- Create indexes for common queries
CREATE INDEX idx_inventory_clinic_id ON inventory(clinic_id);
CREATE INDEX idx_inventory_item_code ON inventory(item_code);
CREATE INDEX idx_inventory_category ON inventory(category);
CREATE INDEX idx_inventory_is_active ON inventory(is_active);
CREATE INDEX idx_inventory_expiry_date ON inventory(expiry_date);
CREATE INDEX idx_inventory_created_at ON inventory(created_at DESC);

-- ════════════════════════════════════════════════════════════════════════════
-- Row Level Security (RLS) Policies
-- ════════════════════════════════════════════════════════════════════════════

-- Enable RLS on inventory table
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;

-- Policy: Clinic staff can view inventory in their clinic
CREATE POLICY "Clinic staff can view clinic inventory"
  ON inventory FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can create inventory items
CREATE POLICY "Clinic staff can create inventory items"
  ON inventory FOR INSERT
  WITH CHECK (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Clinic staff can update inventory items
CREATE POLICY "Clinic staff can update inventory items"
  ON inventory FOR UPDATE
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Super admins can manage all inventory
CREATE POLICY "Super admins can manage all inventory"
  ON inventory FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ══════════════════════════════════════════════════════════════════════════════
-- Triggers
-- ══════════════════════════════════════════════════════════════════════════

-- Create function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_inventory_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic timestamp update
CREATE TRIGGER update_inventory_updated_at
  BEFORE UPDATE ON inventory
  FOR EACH ROW
  EXECUTE FUNCTION update_inventory_updated_at();

-- ══════════════════════════════════════════════════════════════════════════════
-- Comments
-- ══════════════════════════════════════════════════════════════════════════

COMMENT ON TABLE inventory IS 'Clinic inventory and stock management';
COMMENT ON COLUMN inventory.item_code IS 'Unique item identification code';
COMMENT ON COLUMN inventory.current_stock IS 'Current quantity in stock';
COMMENT ON COLUMN inventory.minimum_stock IS 'Minimum stock level before reordering';
COMMENT ON COLUMN inventory.maximum_stock IS 'Maximum stock capacity';
COMMENT ON COLUMN inventory.reorder_quantity IS 'Quantity to reorder when stock reaches minimum';
COMMENT ON COLUMN inventory.expiry_date IS 'Expiry date for perishable items';

-- ══════════════════════════════════════════════════════════════════════════════
-- Inventory Transactions Table
-- ════════════════════════════════════════════════════════════════════════════

-- Create inventory_transactions table for tracking stock movements
CREATE TABLE IF NOT EXISTS inventory_transactions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Key
  inventory_id UUID NOT NULL REFERENCES inventory(id) ON DELETE CASCADE,

  -- Transaction Information
  transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'return', 'adjustment', 'transfer', 'expiry', 'damage', 'restock')),
  
  -- Quantity
  quantity INTEGER NOT NULL,
  unit_cost DECIMAL(10, 2),
  total_cost DECIMAL(10, 2),
  
  -- Reference Information
  reference_number VARCHAR(100),
  notes TEXT,
  
  -- Performed By
  performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Transaction Date
  transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for inventory_transactions
CREATE INDEX idx_inventory_transactions_inventory_id ON inventory_transactions(inventory_id);
CREATE INDEX idx_inventory_transactions_transaction_type ON inventory_transactions(transaction_type);
CREATE INDEX idx_inventory_transactions_transaction_date ON inventory_transactions(transaction_date);
CREATE INDEX idx_inventory_transactions_performed_by ON inventory_transactions(performed_by);

-- Add RLS policies for inventory_transactions
ALTER TABLE inventory_transactions ENABLE ROW LEVEL SECURITY;

-- Policy: Clinic staff can view transactions for their clinic inventory
CREATE POLICY "Clinic staff can view inventory transactions"
  ON inventory_transactions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM inventory i
      JOIN clinic_staff cs ON i.clinic_id = cs.clinic_id
      WHERE i.id = inventory_transactions.inventory_id
      AND cs.user_id = auth.uid()
    )
  );

-- Add comments
COMMENT ON TABLE inventory_transactions IS 'Inventory transaction history';
COMMENT ON COLUMN inventory_transactions.transaction_type IS 'Type of transaction: purchase, sale, return, adjustment, transfer, expiry, damage';
COMMENT ON COLUMN inventory_transactions.quantity IS 'Quantity (positive for additions, negative for deductions)';
COMMENT ON COLUMN inventory_transactions.total_cost IS 'Total cost of transaction';

-- ════════════════════════════════════════════════════════════════════════════
-- Stock Update Trigger
-- ══════════════════════════════════════════════════════════════════════════════

-- Create function to update inventory stock on transaction
CREATE OR REPLACE FUNCTION update_inventory_stock()
RETURNS TRIGGER AS $$
BEGIN
  -- Update current stock based on transaction type
  IF NEW.transaction_type IN ('purchase', 'adjustment', 'restock') THEN
    UPDATE inventory
    SET current_stock = current_stock + NEW.quantity
    WHERE id = NEW.inventory_id;
  ELSIF NEW.transaction_type IN ('sale', 'return', 'expiry', 'damage') THEN
    UPDATE inventory
    SET current_stock = current_stock - NEW.quantity
    WHERE id = NEW.inventory_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updating inventory stock
CREATE TRIGGER update_inventory_stock_on_transaction
  AFTER INSERT ON inventory_transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_inventory_stock();

-- ══════════════════════════════════════════════════════════════════════════════
-- Reports Table
-- ════════════════════════════════════════════════════════════════════════════

-- Create reports table for generated reports
CREATE TABLE IF NOT EXISTS reports (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Report Information
  report_name VARCHAR(255) NOT NULL,
  report_name_ar VARCHAR(255),
  report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('appointment', 'patient', 'financial', 'inventory', 'lab_result', 'staff', 'custom')),
  
  -- Foreign Keys
  clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
  generated_by UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Report Parameters
  start_date DATE,
  end_date,
  parameters JSONB,
  
  -- Report Output
  file_url TEXT,
  file_format VARCHAR(10) DEFAULT 'pdf' CHECK (file_format IN ('pdf', 'xlsx', 'csv', 'json')),
  file_size_bytes BIGINT,
  
  -- Status
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'generating', 'completed', 'failed')),
  error_message TEXT,
  
  -- Statistics
  record_count INTEGER,
  
  -- System Fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for reports
CREATE INDEX idx_reports_clinic_id ON reports(clinic_id);
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_report_type ON reports(report_type);
CREATE INDEX idx_reports_start_date ON reports(start_date);
CREATE INDEX idx_reports_end_date ON reports(end_date);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);

-- Add RLS policies for reports
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own reports
CREATE POLICY "Users can view their own reports"
  ON reports FOR SELECT
  USING (generated_by = auth.uid());

-- Policy: Clinic staff can view clinic reports
CREATE POLICY "Clinic staff can view clinic reports"
  ON reports FOR SELECT
  USING (
    clinic_id IN (
      SELECT clinic_id FROM clinic_staff
      WHERE user_id = auth.uid()
    )
  );

-- Policy: Authorized users can create reports
CREATE POLICY "Authorized users can create reports"
  ON reports FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL);

-- Policy: Super admins can manage all reports
CREATE POLICY "Super admins can manage all reports"
  ON reports FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- Add comments
COMMENT ON TABLE reports IS 'Generated reports';
COMMENT ON COLUMN reports.report_type IS 'Type of report: appointment, patient, financial, inventory, lab_result, staff, custom';
COMMENT ON COLUMN reports.parameters IS 'JSON object containing report parameters';
COMMENT ON COLUMN reports.file_format IS 'Output file format: pdf, xlsx, csv, json';
COMMENT ON COLUMN reports.status IS 'Report generation status: pending, generating, completed, failed';
COMMENT ON COLUMN reports.record_count IS 'Number of records in the report';