import csv
from datetime import datetime, timezone
from pathlib import Path


def main():
    output_dir = Path("data/raw")
    output_dir.mkdir(parents=True, exist_ok=True)

    file_path = output_dir / "orders.csv"

    now = datetime.now(timezone.utc)

    with open(file_path, "w", newline="") as f:
        writer = csv.writer(f)

        # header
        writer.writerow([
            "order_id",
            "customer_id",
            "order_ts",
            "status",
            "payment_method",
            "currency",
            "order_total",
            "updated_at",
        ])

        for i in range(100):
            writer.writerow([
                i + 1,
                1000 + i,
                now.isoformat(),
                "delivered",
                "card",
                "USD",
                99.99 + i,
                now.isoformat(),
            ])

    print(f"Generated CSV at {file_path}")


if __name__ == "__main__":
    main()
