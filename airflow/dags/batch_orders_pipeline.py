from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator

# import application code like a normal package
from batch_pipeline.generate_orders_csv import main as generate_csv
from batch_pipeline.load_orders_from_csv import main as load_csv


default_args = {
    "owner": "data-engineer",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


with DAG(
    dag_id="batch_orders_pipeline",
    description="Generate orders CSV and load into raw.orders",
    default_args=default_args,
    schedule_interval=None,          # manual trigger for now
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["batch", "orders"],
) as dag:

    generate_orders_csv = PythonOperator(
        task_id="generate_orders_csv",
        python_callable=generate_csv,
    )

    load_orders_csv = PythonOperator(
        task_id="load_orders_csv",
        python_callable=load_csv,
    )

    generate_orders_csv >> load_orders_csv
