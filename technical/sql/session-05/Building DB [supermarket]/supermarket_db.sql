-- ============================================================
-- SUPERMARKET DATABASE
-- PostgreSQL Database Schema
-- ============================================================
--
-- Main Tables:
--   1. categories
--   2. products
--   3. suppliers
--   4. customers
--   5. purchase_invoices
--   6. purchase_items
--   7. sales_invoices
--   8. sale_items
--
-- Database Flow:
--
--   categories
--        |
--        v
--     products
--      /     \
--     /       \
--    v         v
-- purchase   sale
--  items      items
--    |          |
--    v          v
-- purchase    sales
-- invoices    invoices
--    |          |
--    v          v
-- suppliers   customers
--
-- ============================================================


-- ============================================================
-- 1. CATEGORIES
-- ============================================================
-- Stores product categories.
--
-- Examples:
--   Drinks
--   Dairy
--   Grocery
--   Cleaning
--   Snacks
-- ============================================================

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. PRODUCTS
-- ============================================================
-- Stores all products available in the supermarket.
--
-- Each product belongs to one category.
--
-- Examples:
--   Pepsi 330ml
--   Milk 1 Liter
--   Rice 1kg
--   Potato Chips
-- ============================================================

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(150) NOT NULL,

    barcode VARCHAR(50) UNIQUE,

    category_id BIGINT NOT NULL,

    purchase_price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    sale_price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    min_stock NUMERIC(12, 3) NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Product must belong to an existing category
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Prices cannot be negative
    CONSTRAINT chk_products_purchase_price
        CHECK (purchase_price >= 0),

    CONSTRAINT chk_products_sale_price
        CHECK (sale_price >= 0),

    -- Minimum stock cannot be negative
    CONSTRAINT chk_products_min_stock
        CHECK (min_stock >= 0)
);


-- ============================================================
-- 3. SUPPLIERS
-- ============================================================
-- Stores suppliers who provide products to the supermarket.
--
-- Examples:
--   Pepsi Company
--   Nestle
--   Local Grocery Supplier
-- ============================================================

CREATE TABLE suppliers (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(150) NOT NULL,

    phone VARCHAR(30),

    email VARCHAR(150),

    address TEXT,

    balance NUMERIC(12, 2) NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Supplier balance cannot be negative
    CONSTRAINT chk_suppliers_balance
        CHECK (balance >= 0)
);


-- ============================================================
-- 4. CUSTOMERS
-- ============================================================
-- Stores customers.
--
-- For normal cash sales, customer_id can be NULL in
-- the sales_invoices table.
--
-- This allows us to support:
--   - Cash customers
--   - Registered customers
--   - Credit customers
-- ============================================================

CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(150) NOT NULL,

    phone VARCHAR(30),

    email VARCHAR(150),

    address TEXT,

    balance NUMERIC(12, 2) NOT NULL DEFAULT 0,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Customer balance cannot be negative
    CONSTRAINT chk_customers_balance
        CHECK (balance >= 0)
);


-- ============================================================
-- 5. PURCHASE INVOICES
-- ============================================================
-- Stores the header/master information of purchase invoices.
--
-- One purchase invoice can contain multiple products.
--
-- Example:
--
-- Invoice #1001
-- Supplier: Pepsi Company
-- Date: 2026-09-14
-- Total: 5000
--
-- The products inside this invoice are stored in
-- purchase_items.
-- ============================================================

CREATE TABLE purchase_invoices (
    id BIGSERIAL PRIMARY KEY,

    invoice_number VARCHAR(50) NOT NULL UNIQUE,

    supplier_id BIGINT NOT NULL,

    invoice_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    discount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    remaining_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Invoice must belong to an existing supplier
    CONSTRAINT fk_purchase_invoices_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Amount validations
    CONSTRAINT chk_purchase_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_purchase_discount
        CHECK (discount >= 0),

    CONSTRAINT chk_purchase_paid
        CHECK (paid_amount >= 0),

    CONSTRAINT chk_purchase_remaining
        CHECK (remaining_amount >= 0)
);


-- ============================================================
-- 6. PURCHASE ITEMS
-- ============================================================
-- Stores the products inside each purchase invoice.
--
-- One invoice can have many items.
--
-- Example:
--
-- Purchase Invoice #1001
--
--   Product       Quantity    Price
--   --------------------------------
--   Pepsi             50      10.00
--   Chips             30       7.00
--   Water             40       5.00
--
-- Each row below represents one item in the invoice.
-- ============================================================

CREATE TABLE purchase_items (
    id BIGSERIAL PRIMARY KEY,

    purchase_invoice_id BIGINT NOT NULL,

    product_id BIGINT NOT NULL,

    quantity NUMERIC(12, 3) NOT NULL,

    purchase_price NUMERIC(12, 2) NOT NULL,

    discount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    total NUMERIC(12, 2) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Item belongs to a purchase invoice
    CONSTRAINT fk_purchase_items_invoice
        FOREIGN KEY (purchase_invoice_id)
        REFERENCES purchase_invoices(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Item refers to an existing product
    CONSTRAINT fk_purchase_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Quantity must be greater than zero
    CONSTRAINT chk_purchase_item_quantity
        CHECK (quantity > 0),

    -- Purchase price cannot be negative
    CONSTRAINT chk_purchase_item_price
        CHECK (purchase_price >= 0),

    -- Discount cannot be negative
    CONSTRAINT chk_purchase_item_discount
        CHECK (discount >= 0),

    -- Item total cannot be negative
    CONSTRAINT chk_purchase_item_total
        CHECK (total >= 0)
);


-- ============================================================
-- 7. SALES INVOICES
-- ============================================================
-- Stores the header/master information of sales invoices.
--
-- customer_id is nullable because the customer may be
-- an anonymous cash customer.
--
-- Example:
--
-- Invoice #5001
-- Customer: Ahmed
-- Date: 2026-09-14
-- Total: 350
-- Paid: 350
-- Remaining: 0
-- ============================================================

CREATE TABLE sales_invoices (
    id BIGSERIAL PRIMARY KEY,

    invoice_number VARCHAR(50) NOT NULL UNIQUE,

    customer_id BIGINT,

    invoice_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    discount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    paid_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    remaining_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Customer is optional for cash sales
    CONSTRAINT fk_sales_invoices_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Amount validations
    CONSTRAINT chk_sales_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_sales_discount
        CHECK (discount >= 0),

    CONSTRAINT chk_sales_paid
        CHECK (paid_amount >= 0),

    CONSTRAINT chk_sales_remaining
        CHECK (remaining_amount >= 0)
);


-- ============================================================
-- 8. SALE ITEMS
-- ============================================================
-- Stores the products inside each sales invoice.
--
-- Example:
--
-- Sales Invoice #5001
--
--   Product       Quantity    Sale Price
--   -------------------------------------
--   Pepsi              2        15.00
--   Chips              3        10.00
--   Water              5         7.00
--
-- Each row represents one product sold.
-- ============================================================

CREATE TABLE sale_items (
    id BIGSERIAL PRIMARY KEY,

    sales_invoice_id BIGINT NOT NULL,

    product_id BIGINT NOT NULL,

    quantity NUMERIC(12, 3) NOT NULL,

    sale_price NUMERIC(12, 2) NOT NULL,

    discount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    total NUMERIC(12, 2) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Item belongs to a sales invoice
    CONSTRAINT fk_sale_items_invoice
        FOREIGN KEY (sales_invoice_id)
        REFERENCES sales_invoices(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    -- Item refers to an existing product
    CONSTRAINT fk_sale_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Quantity must be greater than zero
    CONSTRAINT chk_sale_item_quantity
        CHECK (quantity > 0),

    -- Sale price cannot be negative
    CONSTRAINT chk_sale_item_price
        CHECK (sale_price >= 0),

    -- Discount cannot be negative
    CONSTRAINT chk_sale_item_discount
        CHECK (discount >= 0),

    -- Item total cannot be negative
    CONSTRAINT chk_sale_item_total
        CHECK (total >= 0)
);


-- ============================================================
-- INDEXES
-- ============================================================
-- Indexes improve query performance when searching/filtering
-- using foreign keys or frequently used columns.
-- ============================================================


-- Products
CREATE INDEX idx_products_category_id
    ON products(category_id);

CREATE INDEX idx_products_barcode
    ON products(barcode);


-- Purchase invoices
CREATE INDEX idx_purchase_invoices_supplier_id
    ON purchase_invoices(supplier_id);

CREATE INDEX idx_purchase_invoices_date
    ON purchase_invoices(invoice_date);


-- Purchase items
CREATE INDEX idx_purchase_items_invoice_id
    ON purchase_items(purchase_invoice_id);

CREATE INDEX idx_purchase_items_product_id
    ON purchase_items(product_id);


-- Sales invoices
CREATE INDEX idx_sales_invoices_customer_id
    ON sales_invoices(customer_id);

CREATE INDEX idx_sales_invoices_date
    ON sales_invoices(invoice_date);


-- Sale items
CREATE INDEX idx_sale_items_invoice_id
    ON sale_items(sales_invoice_id);

CREATE INDEX idx_sale_items_product_id
    ON sale_items(product_id);


-- ============================================================
-- END OF DATABASE SCHEMA
-- ============================================================