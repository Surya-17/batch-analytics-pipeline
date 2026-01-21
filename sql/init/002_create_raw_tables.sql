CREATE TABLE IF NOT EXISTS raw.orders (
  order_id        BIGINT PRIMARY KEY,
  customer_id     BIGINT NOT NULL,
  order_ts        TIMESTAMP NOT NULL,
  status          TEXT NOT NULL,
  payment_method  TEXT NOT NULL,
  currency        TEXT NOT NULL DEFAULT 'USD',
  order_total     NUMERIC(12,2) NOT NULL,
  updated_at      TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.order_items (
  order_item_id   BIGINT PRIMARY KEY,
  order_id        BIGINT NOT NULL,
  product_id      BIGINT NOT NULL,
  quantity        INT NOT NULL,
  unit_price      NUMERIC(12,2) NOT NULL,
  discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  updated_at      TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.products (
  product_id   BIGINT PRIMARY KEY,
  sku          TEXT NOT NULL,
  product_name TEXT NOT NULL,
  category     TEXT NOT NULL,
  price        NUMERIC(12,2) NOT NULL,
  is_active    BOOLEAN NOT NULL,
  updated_at   TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS raw.web_events (
  event_id      BIGINT PRIMARY KEY,
  event_ts      TIMESTAMP NOT NULL,
  user_id       BIGINT,
  session_id    TEXT NOT NULL,
  event_type    TEXT NOT NULL,
  product_id    BIGINT,
  page_url      TEXT,
  referrer      TEXT
);
