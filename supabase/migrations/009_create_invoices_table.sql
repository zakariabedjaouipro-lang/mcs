-- Create invoices table
-- This table stores invoice information

CREATE TABLE IF NOT EXISTS invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    patient_id UUID REFERENCES patients(id) ON DELETE SET NULL,
    doctor_id UUID REFERENCES doctors(id) ON DELETE SET NULL,
    clinic_id UUID REFERENCES clinics(id) ON DELETE SET NULL,
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    invoice_date DATE NOT NULL,
    due_date DATE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'paid', 'overdue', 'cancelled', 'refunded')),
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method VARCHAR(50),
    payment_date TIMESTAMP WITH TIME ZONE,
    payment_reference VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_invoices_patient_id ON invoices(patient_id);
CREATE INDEX idx_invoices_doctor_id ON invoices(doctor_id);
CREATE INDEX idx_invoices_clinic_id ON invoices(clinic_id);
CREATE INDEX idx_invoices_appointment_id ON invoices(appointment_id);
CREATE INDEX idx_invoices_invoice_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_invoice_date ON invoices(invoice_date);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);
CREATE INDEX idx_invoices_created_at ON invoices(created_at DESC);

-- Add RLS policies
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

-- Policy: Clinic staff can view clinic invoices
CREATE POLICY "Clinic staff can view clinic invoices"
    ON invoices FOR SELECT
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Clinic staff can create invoices
CREATE POLICY "Clinic staff can create invoices"
    ON invoices FOR INSERT
    WITH CHECK (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Policy: Clinic staff can update invoices
CREATE POLICY "Clinic staff can update invoices"
    ON invoices FOR UPDATE
    USING (
        clinic_id IN (
            SELECT clinic_id FROM clinic_staff
            WHERE user_id = auth.uid()
        )
    );

-- Create trigger for updated_at
CREATE TRIGGER update_invoices_updated_at
    BEFORE UPDATE ON invoices
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE invoices IS 'Invoice information for services rendered';
COMMENT ON COLUMN invoices.status IS 'Invoice status: pending, sent, paid, overdue, cancelled, refunded';
COMMENT ON COLUMN invoices.payment_method IS 'Method of payment: cash, card, insurance, etc.';

-- Create invoice_items table for individual line items
CREATE TABLE IF NOT EXISTS invoice_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID REFERENCES invoices(id) ON DELETE CASCADE NOT NULL,
    item_type VARCHAR(50) CHECK (item_type IN ('service', 'medication', 'lab_test', 'procedure', 'other')),
    item_name VARCHAR(255) NOT NULL,
    item_name_ar VARCHAR(255),
    description TEXT,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
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