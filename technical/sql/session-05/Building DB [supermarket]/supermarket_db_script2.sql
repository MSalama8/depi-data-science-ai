-- ============================================================
-- SUPERMARKET DATABASE
-- ADDITIONAL TABLES
-- PostgreSQL
-- ============================================================
--
-- This script adds the remaining supporting tables.
--
-- Existing tables:
--   categories
--   products
--   suppliers
--   customers
--   purchase_invoices
--   purchase_items
--   sales_invoices
--   sale_items
--
-- New tables:
--   1. units
--   2. payment_methods
--   3. stock_movements
--   4. payments
--   5. roles
--   6. users
--   7. expenses
--
-- IMPORTANT:
-- Run the original database schema first.
-- Then run this script.
-- ============================================================


-- ============================================================
-- 1. UNITS
-- ============================================================
-- Stores product measurement units.
--
-- Examples:
--   Piece
--   Kilogram
--   Gram
--   Liter
--   Box
--   Carton
--
-- A product can later be linked to one unit.
-- ============================================================

CREATE TABLE units (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(50) NOT NULL UNIQUE,

    abbreviation VARCHAR(20) UNIQUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. PAYMENT METHODS
-- ============================================================
-- Stores available payment methods.
--
-- Examples:
--   Cash
--   Visa
--   Mastercard
--   Instapay
--   Wallet
-- ============================================================

CREATE TABLE payment_methods (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(50) NOT NULL UNIQUE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 3. STOCK MOVEMENTS
-- ============================================================
-- Stores every movement that changes product stock.
--
-- Examples:
--
-- Purchase:
--     Product enters the warehouse
--     quantity = +100
--
-- Sale:
--     Product leaves the warehouse
--     quantity = -5
--
-- Return:
--     Product comes back
--     quantity = +2
--
-- Adjustment:
--     Manual stock correction
--
-- This table gives us a complete stock movement history.
-- ============================================================

CREATE TABLE stock_movements (
    id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL,

    movement_type VARCHAR(30) NOT NULL,

    quantity NUMERIC(12, 3) NOT NULL,

    reference_type VARCHAR(30),

    reference_id BIGINT,

    movement_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Movement must refer to an existing product
    CONSTRAINT fk_stock_movements_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Quantity cannot be zero
    CONSTRAINT chk_stock_movements_quantity
        CHECK (quantity <> 0),

    -- Only valid movement types are allowed
    CONSTRAINT chk_stock_movements_type
        CHECK (
            movement_type IN (
                'PURCHASE',
                'SALE',
                'PURCHASE_RETURN',
                'SALE_RETURN',
                'ADJUSTMENT',
                'DAMAGE'
            )
        )
);


-- ============================================================
-- 4. PAYMENTS
-- ============================================================
-- Stores actual payments made against invoices.
--
-- This allows an invoice to have multiple payments.
--
-- Example:
--
-- Invoice total = 1000
--
-- Payment 1 = 500 Cash
-- Payment 2 = 300 Visa
-- Payment 3 = 200 Instapay
--
-- This is more flexible than storing only one payment
-- inside the invoice table.
-- ============================================================

CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,

    payment_type VARCHAR(20) NOT NULL,

    purchase_invoice_id BIGINT,

    sales_invoice_id BIGINT,

    payment_method_id BIGINT NOT NULL,

    amount NUMERIC(12, 2) NOT NULL,

    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Payment method must exist
    CONSTRAINT fk_payments_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Purchase invoice is optional
    CONSTRAINT fk_payments_purchase_invoice
        FOREIGN KEY (purchase_invoice_id)
        REFERENCES purchase_invoices(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Sales invoice is optional
    CONSTRAINT fk_payments_sales_invoice
        FOREIGN KEY (sales_invoice_id)
        REFERENCES sales_invoices(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Payment amount must be positive
    CONSTRAINT chk_payments_amount
        CHECK (amount > 0),

    -- Payment must be either for a purchase or a sale
    CONSTRAINT chk_payments_invoice_type
        CHECK (
            (purchase_invoice_id IS NOT NULL AND sales_invoice_id IS NULL)
            OR
            (purchase_invoice_id IS NULL AND sales_invoice_id IS NOT NULL)
        ),

    -- Payment type must match the invoice type
    CONSTRAINT chk_payments_type
        CHECK (
            (payment_type = 'PURCHASE'
                AND purchase_invoice_id IS NOT NULL
                AND sales_invoice_id IS NULL)
            OR
            (payment_type = 'SALE'
                AND sales_invoice_id IS NOT NULL
                AND purchase_invoice_id IS NULL)
        )
);


-- ============================================================
-- 5. ROLES
-- ============================================================
-- Stores system roles.
--
-- Examples:
--   Admin
--   Manager
--   Cashier
--   Storekeeper
-- ============================================================

CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(50) NOT NULL UNIQUE,

    description TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 6. USERS
-- ============================================================
-- Stores users who can access the supermarket system.
--
-- Passwords must NEVER be stored as plain text.
-- The password_hash column should contain a secure hash.
-- ============================================================

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,

    full_name VARCHAR(150) NOT NULL,

    username VARCHAR(100) NOT NULL UNIQUE,

    password_hash TEXT NOT NULL,

    role_id BIGINT NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    last_login TIMESTAMP,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- User must have an existing role
    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- 7. EXPENSES
-- ============================================================
-- Stores business expenses that are not directly related
-- to purchasing products.
--
-- Examples:
--   Rent
--   Electricity
--   Water
--   Internet
--   Salaries
--   Transportation
--   Maintenance
-- ============================================================

CREATE TABLE expenses (
    id BIGSERIAL PRIMARY KEY,

    title VARCHAR(150) NOT NULL,

    description TEXT,

    amount NUMERIC(12, 2) NOT NULL,

    expense_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    payment_method_id BIGINT,

    created_by BIGINT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Payment method is optional
    CONSTRAINT fk_expenses_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- User who created the expense
    CONSTRAINT fk_expenses_user
        FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    -- Expense amount must be positive
    CONSTRAINT chk_expenses_amount
        CHECK (amount > 0)
);


-- ============================================================
-- INDEXES
-- ============================================================
-- Indexes improve query performance.
-- ============================================================


-- Stock movements
CREATE INDEX idx_stock_movements_product_id
    ON stock_movements(product_id);

CREATE INDEX idx_stock_movements_date
    ON stock_movements(movement_date);

CREATE INDEX idx_stock_movements_type
    ON stock_movements(movement_type);


-- Payments
CREATE INDEX idx_payments_purchase_invoice_id
    ON payments(purchase_invoice_id);

CREATE INDEX idx_payments_sales_invoice_id
    ON payments(sales_invoice_id);

CREATE INDEX idx_payments_payment_method_id
    ON payments(payment_method_id);

CREATE INDEX idx_payments_date
    ON payments(payment_date);


-- Users
CREATE INDEX idx_users_role_id
    ON users(role_id);


-- Expenses
CREATE INDEX idx_expenses_payment_method_id
    ON expenses(payment_method_id);

CREATE INDEX idx_expenses_created_by
    ON expenses(created_by);

CREATE INDEX idx_expenses_date
    ON expenses(expense_date);


-- ============================================================
-- BASIC SEED DATA
-- ============================================================


-- ============================================================
-- UNITS
-- ============================================================

INSERT INTO units (name, abbreviation)
VALUES
    ('Piece', 'pcs'),
    ('Kilogram', 'kg'),
    ('Gram', 'g'),
    ('Liter', 'L'),
    ('Milliliter', 'ml'),
    ('Box', 'box'),
    ('Carton', 'ctn');


-- ============================================================
-- PAYMENT METHODS
-- ============================================================

INSERT INTO payment_methods (name)
VALUES
    ('Cash'),
    ('Visa'),
    ('Mastercard'),
    ('Instapay'),
    ('Wallet');


-- ============================================================
-- ROLES
-- ============================================================

INSERT INTO roles (name, description)
VALUES
    ('Admin', 'Full system access'),
    ('Manager', 'Management and reporting access'),
    ('Cashier', 'Sales and customer transactions'),
    ('Storekeeper', 'Inventory and purchasing operations');


-- ============================================================
-- SAMPLE USERS
-- ============================================================
-- These passwords are placeholders only.
-- In a real application, store a secure password hash.
-- ============================================================

INSERT INTO users
    (full_name, username, password_hash, role_id)
VALUES
    (
        'System Administrator',
        'admin',
        'PLACEHOLDER_HASH',
        1
    ),
    (
        'Supermarket Manager',
        'manager',
        'PLACEHOLDER_HASH',
        2
    ),
    (
        'Main Cashier',
        'cashier',
        'PLACEHOLDER_HASH',
        3
    ),
    (
        'Store Keeper',
        'storekeeper',
        'PLACEHOLDER_HASH',
        4
    );


-- ============================================================
-- SAMPLE EXPENSES
-- ============================================================

INSERT INTO expenses
    (
        title,
        description,
        amount,
        expense_date,
        payment_method_id,
        created_by
    )
VALUES
    (
        'Shop Rent',
        'Monthly shop rent',
        5000.00,
        '2026-09-01 09:00:00',
        1,
        1
    ),
    (
        'Electricity Bill',
        'Monthly electricity bill',
        1200.00,
        '2026-09-05 10:00:00',
        1,
        2
    ),
    (
        'Internet',
        'Monthly internet subscription',
        500.00,
        '2026-09-06 11:00:00',
        1,
        2
    ),
    (
        'Shop Maintenance',
        'Air conditioner maintenance',
        750.00,
        '2026-09-08 14:00:00',
        1,
        2
    );


-- ============================================================
-- SAMPLE STOCK MOVEMENTS
-- ============================================================
-- These movements represent products entering the store
-- through purchases and leaving the store through sales.
--
-- Purchase movements are positive.
-- Sale movements are negative.
-- ============================================================


-- Purchase movements
INSERT INTO stock_movements
    (
        product_id,
        movement_type,
        quantity,
        reference_type,
        reference_id,
        movement_date,
        notes
    )
VALUES
    (1, 'PURCHASE', 50, 'PURCHASE_INVOICE', 2,
        '2026-09-03 10:15:00', 'Stock received'),

    (2, 'PURCHASE', 50, 'PURCHASE_INVOICE', 2,
        '2026-09-03 10:15:00', 'Stock received'),

    (3, 'PURCHASE', 50, 'PURCHASE_INVOICE', 2,
        '2026-09-03 10:15:00', 'Stock received'),

    (4, 'PURCHASE', 70, 'PURCHASE_INVOICE', 2,
        '2026-09-03 10:15:00', 'Stock received'),

    (6, 'PURCHASE', 30, 'PURCHASE_INVOICE', 4,
        '2026-09-07 08:45:00', 'Stock received'),

    (7, 'PURCHASE', 50, 'PURCHASE_INVOICE', 4,
        '2026-09-07 08:45:00', 'Stock received'),

    (9, 'PURCHASE', 15, 'PURCHASE_INVOICE', 4,
        '2026-09-07 08:45:00', 'Stock received');


-- Sale movements
INSERT INTO stock_movements
    (
        product_id,
        movement_type,
        quantity,
        reference_type,
        reference_id,
        movement_date,
        notes
    )
VALUES
    (1, 'SALE', -3, 'SALES_INVOICE', 1,
        '2026-09-10 10:15:00', 'Product sold'),

    (15, 'SALE', -5, 'SALES_INVOICE', 1,
        '2026-09-10 10:15:00', 'Product sold'),

    (17, 'SALE', -2, 'SALES_INVOICE', 1,
        '2026-09-10 10:15:00', 'Product sold'),

    (23, 'SALE', -1, 'SALES_INVOICE', 1,
        '2026-09-10 10:15:00', 'Product sold'),

    (4, 'SALE', -5, 'SALES_INVOICE', 2,
        '2026-09-10 11:30:00', 'Product sold'),

    (15, 'SALE', -3, 'SALES_INVOICE', 2,
        '2026-09-10 11:30:00', 'Product sold'),

    (14, 'SALE', -2, 'SALES_INVOICE', 2,
        '2026-09-10 11:30:00', 'Product sold'),

    (6, 'SALE', -3, 'SALES_INVOICE', 3,
        '2026-09-11 12:10:00', 'Product sold'),

    (10, 'SALE', -2, 'SALES_INVOICE', 3,
        '2026-09-11 12:10:00', 'Product sold'),

    (13, 'SALE', -1, 'SALES_INVOICE', 3,
        '2026-09-11 12:10:00', 'Product sold');


-- ============================================================
-- END OF SCRIPT
-- ============================================================

