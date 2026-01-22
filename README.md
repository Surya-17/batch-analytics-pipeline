# Batch Analytics Data Pipeline (Airflow + Postgres)

## Overview

This project implements a **containerized batch data engineering pipeline** using **Apache Airflow** and **Postgres**.  
It demonstrates **append-only raw ingestion**, **batch semantics**, and **layered warehouse modeling** (raw → staging).

Each Airflow DAG run simulates the ingestion of a new batch of source data and persists it immutably in the warehouse.

---

## Architecture

### Components

- **Postgres 15**
  - `airflow` database → Airflow metadata (DAGs, task state, auth)
  - `de_dw` database → Analytics warehouse
    - Schemas: `raw`, `stg`
- **Apache Airflow 2.8.3**
  - Executor: `LocalExecutor`
  - Services:
    - Webserver
    - Scheduler
    - Init container (DB bootstrap)

All services are orchestrated via **Docker Compose**.

---

## Data Model

### Raw Layer (`raw` schema)

Raw tables are **append-only** and store data exactly as received, including duplicates across batches.

Example:
- `raw.orders`
  - Allows duplicate `order_id` values
  - Each batch is identified by a shared `updated_at` timestamp

Raw data is never mutated or deduplicated.

---

### Staging Layer (`stg` schema)

The staging layer applies **business logic** to raw data.

Example:
- `stg.orders_latest`
  - One row per `order_id`
  - Keeps the **latest record by `updated_at`**

This separation ensures:
- Full historical traceability in raw
- Clean, analytics-ready data in staging

---

## Pipeline Flow

Each DAG run performs the following steps:

1. **Generate batch data**
   - Create a synthetic batch of 100 orders
   - Assign a single batch timestamp
   - Write to `data/raw/orders.csv` (overwritten each run)

2. **Load raw data**
   - Read CSV
   - Append rows to `raw.orders`
   - No deduplication

3. **Build staging model**
   - Deduplicate raw data
   - Materialize `stg.orders_latest`

Running the DAG multiple times produces multiple immutable batches in the raw layer.

---

## Example Behavior

After 3 DAG runs:

- `raw.orders`
  - 300 total rows
  - 3 distinct batch timestamps
  - 100 distinct `order_id` values

- `stg.orders_latest`
  - 100 rows
  - One per `order_id`
  - All from the latest batch

---

## Running the Project

### Prerequisites
- Docker
- Docker Compose

### Start Services

```bash
docker compose up -d
