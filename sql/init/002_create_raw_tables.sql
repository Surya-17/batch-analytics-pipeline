CREATE TABLE IF NOT EXISTS raw.orders (
  raw_order_id   BIGSERIAL PRIMARY KEY,   -- technical PK
  order_id       BIGINT NOT NULL,          -- business ID (duplicates allowed)
  customer_id    BIGINT NOT NULL,
  order_ts       TIMESTAMP NOT NULL,
  status         TEXT NOT NULL,
  payment_method TEXT NOT NULL,
  currency       TEXT NOT NULL,
  order_total    NUMERIC(12,2) NOT NULL,
  updated_at     TIMESTAMP NOT NULL        -- batch timestamp
);

CREATE INDEX IF NOT EXISTS ix_raw_orders_order_id
  ON raw.orders(order_id);

CREATE INDEX IF NOT EXISTS ix_raw_orders_updated_at
  ON raw.orders(updated_at);


CREATE TABLE IF NOT EXISTS raw.order_items (
  raw_order_item_id BIGSERIAL PRIMARY KEY, -- technical PK
  order_item_id     BIGINT NOT NULL,        -- business ID
  order_id          BIGINT NOT NULL,
  product_id        BIGINT NOT NULL,
  quantity          INT NOT NULL,
  unit_price        NUMERIC(12,2) NOT NULL,
  discount_amount   NUMERIC(12,2) NOT NULL DEFAULT 0,
  updated_at        TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS ix_raw_order_items_order_id
  ON raw.order_items(order_id);

CREATE INDEX IF NOT EXISTS ix_raw_order_items_updated_at
  ON raw.order_items(updated_at);

CREATE TABLE IF NOT EXISTS raw.order_items (
  raw_order_item_id BIGSERIAL PRIMARY KEY, -- technical PK
  order_item_id     BIGINT NOT NULL,        -- business ID
  order_id          BIGINT NOT NULL,
  product_id        BIGINT NOT NULL,
  quantity          INT NOT NULL,
  unit_price        NUMERIC(12,2) NOT NULL,
  discount_amount   NUMERIC(12,2) NOT NULL DEFAULT 0,
  updated_at        TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS ix_raw_order_items_order_id
  ON raw.order_items(order_id);

CREATE INDEX IF NOT EXISTS ix_raw_order_items_updated_at
  ON raw.order_items(updated_at);

CREATE TABLE IF NOT EXISTS raw.products (
  raw_product_id BIGSERIAL PRIMARY KEY, -- technical PK
  product_id     BIGINT NOT NULL,        -- business ID
  sku            TEXT NOT NULL,
  product_name   TEXT NOT NULL,
  category       TEXT NOT NULL,
  price          NUMERIC(12,2) NOT NULL,
  is_active      BOOLEAN NOT NULL,
  updated_at     TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS ix_raw_products_product_id
  ON raw.products(product_id);

CREATE INDEX IF NOT EXISTS ix_raw_products_updated_at
  ON raw.products(updated_at);

CREATE TABLE IF NOT EXISTS raw.web_events (
  raw_event_id BIGSERIAL PRIMARY KEY, -- technical PK
  event_id     BIGINT NOT NULL,        -- business ID (can repeat)
  event_ts     TIMESTAMP NOT NULL,
  user_id      BIGINT,
  session_id   TEXT NOT NULL,
  event_type   TEXT NOT NULL,
  product_id   BIGINT,
  page_url     TEXT,
  referrer     TEXT,
  updated_at   TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS ix_raw_web_events_event_id
  ON raw.web_events(event_id);

CREATE INDEX IF NOT EXISTS ix_raw_web_events_updated_at
  ON raw.web_events(updated_at);
