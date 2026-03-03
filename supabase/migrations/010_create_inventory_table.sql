-- Create inventory table
-- This table stores inventory information

CREATE TABLE IF NOT EXISTS inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id UUID REFERENCES clinics(id) ON DELETE CASCADE NOT NULL,
    item_code VARCHAR(50) UNIQUE NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    item_name_ar VARCHAR(255),
    category VARCHAR(100),
    description TEXT,
    unit VARCHAR(50) DEFAULT 'piece',
    current_stock INTEGER NOT NULL DEFAULT 0,
    minimum_stock INTEGER NOT NULL DEFAULT 10,
    maximum_stock INTEGER NOT NULL DEFAULT 1000,
    reorder_quantity INTEGER NOT NULL DEFAULT 50,
    unit_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    selling_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'USD',
    supplier VARCHAR(255),
    supplier_contact VARCHAR(255),
    expiry_date DATE,
    batch_number VARCHAR(100),
    storage_location VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_inventory_clinic_id ON inventory(clinic_id);
CREATE INDEX idx_inventory_item_code ON inventory(item_code);
CREATE INDEX idx_inventory_category ON inventory(category);
CREATE INDEX idx_inventory_is_active ON inventory(is_active);
CREATE INDEX idx_inventory_expiry_date ON inventory(expiry_date);
CREATE INDEX idx_inventory_created_at ON inventory(created_at DESC);

-- Add RLS policies
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

-- Create trigger for updated_at
CREATE TRIGGER update_inventory_updated_at
    BEFORE UPDATE ON inventory
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE inventory IS 'Clinic inventory and stock management';
COMMENT ON COLUMN inventory.item_code IS 'Unique item identification code';
COMMENT ON COLUMN inventory.current_stock IS 'Current quantity in stock';
COMMENT ON COLUMN inventory.minimum_stock IS 'Minimum stock level before reordering';
COMMENT ON COLUMN inventory.maximum_stock IS 'Maximum stock capacity';
COMMENT ON COLUMN inventory.reorder_quantity IS 'Quantity to reorder when stock reaches minimum';
COMMENT ON COLUMN inventory.expiry_date IS 'Expiry date for perishable items';

-- Create inventory_transactions table for tracking stock movements
CREATE TABLE IF NOT EXISTS inventory_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inventory_id UUID REFERENCES inventory(id) ON DELETE CASCADE NOT NULL,
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'return', 'adjustment', 'transfer', 'expiry', 'damage')),
    quantity INTEGER NOT NULL,
    unit_cost DECIMAL(10, 2),
    total_cost DECIMAL(10, 2),
    reference_number VARCHAR(100),
    notes TEXT,
    performed_by UUID REFERENCES users(id) ON DELETE SET NULL,
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

-- Create function to update inventory stock on transaction
CREATE OR REPLACE FUNCTION update_inventory_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Update current stock based on transaction type
    IF NEW.transaction_type IN ('purchase', 'adjustment') THEN
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