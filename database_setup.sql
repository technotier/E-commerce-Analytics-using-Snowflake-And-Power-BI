CREATE SCHEMA IF NOT EXISTS raw_schema;
CREATE SCHEMA IF NOT EXISTS analytics_schema;

-- create customers table
CREATE TABLE raw_schema.customers (
    customer_id      BIGINT PRIMARY KEY,
    first_name       VARCHAR(100) NOT NULL,
    last_name        VARCHAR(100),
    email            VARCHAR(255) NOT NULL UNIQUE,
    gender           VARCHAR(20),
    date_of_birth    DATE NOT NULL,
    city             VARCHAR(100),
    country          VARCHAR(100),
    signup_date      DATE NOT NULL,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_customers_gender
        CHECK (gender IN ('Male', 'Female', 'Other') OR gender IS NULL)
);

-- create indexes for performance
CREATE INDEX idx_customers_country ON raw_schema.customers(country);
CREATE INDEX idx_customers_signup_date ON raw_schema.customers(signup_date);

-- create category table
CREATE TABLE raw_schema.categories (
    category_id    BIGINT PRIMARY KEY,
    category_name  VARCHAR(100) NOT NULL UNIQUE,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- create products table
CREATE TABLE raw_schema.products (
    product_id       BIGINT PRIMARY KEY,
    category_id      BIGINT NOT NULL,
    product_name     VARCHAR(150) NOT NULL,
    sale_price       NUMERIC(10, 2) NOT NULL,
    cost_price       NUMERIC(10, 2) NOT NULL,
    stock_quantity   INT NOT NULL,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES raw_schema.categories(category_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_products_price
        CHECK (sale_price >= 0 AND cost_price >= 0),

    CONSTRAINT chk_products_stock
        CHECK (stock_quantity >= 0)
);

-- create indexes for performance
CREATE INDEX idx_products_category_id ON raw_schema.products(category_id);
CREATE INDEX idx_products_product_name ON raw_schema.products(product_name);

-- create orders table
CREATE TABLE raw_schema.orders (
    order_id       BIGINT PRIMARY KEY,
    customer_id    BIGINT NOT NULL,
    order_date     DATE NOT NULL,
    order_status   VARCHAR(50) NOT NULL,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES raw_schema.customers(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_orders_status
        CHECK (order_status IN ('Pending', 'Completed', 'Cancelled', 'Returned'))
);

-- create indexes for performance
CREATE INDEX idx_orders_customer_id ON raw_schema.orders(customer_id);
CREATE INDEX idx_orders_order_date ON raw_schema.orders(order_date);

-- create order_items table
CREATE TABLE raw_schema.order_items (
    order_item_id   BIGINT PRIMARY KEY,
    order_id        BIGINT NOT NULL,
    product_id      BIGINT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      NUMERIC(10, 2) NOT NULL,
    discount_amount NUMERIC(10, 2) DEFAULT 0,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES raw_schema.orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES raw_schema.products(product_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_discount
        CHECK (discount_amount >= 0)
);

-- create indexes for performance 
CREATE INDEX idx_order_items_order_id ON raw_schema.order_items(order_id);
CREATE INDEX idx_order_items_product_id ON raw_schema.order_items(product_id);

