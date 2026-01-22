import csv
from pathlib import Path
from datetime import datetime
from batch_pipeline.db import get_connection
from decimal import Decimal


EXPECTED_COLUMNS = [
    "order_id",
    "customer_id",
    "order_ts",
    "status",
    "payment_method",
    "currency",
    "order_total",
    "updated_at",
]


def main():
    csv_path = Path("data/raw/orders.csv")

    if not csv_path.exists():
        raise FileNotFoundError(f"CSV not found: {csv_path}")

    rows = []

    with open(csv_path, newline="") as f:
        reader = csv.DictReader(f)

        # 1) Validate header
        if reader.fieldnames != EXPECTED_COLUMNS:
            raise ValueError(
                f"Unexpected CSV schema. "
                f"Expected {EXPECTED_COLUMNS}, got {reader.fieldnames}"
            )

        # 2) Parse rows
        for row in reader:
            rows.append(
                (
                    int(row["order_id"]),
                    int(row["customer_id"]),
                    datetime.fromisoformat(row["order_ts"]),
                    row["status"],
                    row["payment_method"],
                    row["currency"],
                    Decimal(row["order_total"]),
                    datetime.fromisoformat(row["updated_at"]),
                )
            )

    if not rows:
        print("No rows found in CSV. Nothing to load.")
        return

    conn = get_connection()
    cur = conn.cursor()

    sql = """
        INSERT INTO raw.orders (
            order_id,
            customer_id,
            order_ts,
            status,
            payment_method,
            currency,
            order_total,
            updated_at
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """

    cur.executemany(sql, rows)
    conn.commit()

    cur.close()
    conn.close()

    print(f"Loaded {len(rows)} rows into raw.orders")


if __name__ == "__main__":
    main()
