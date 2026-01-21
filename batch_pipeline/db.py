import os
import psycopg2


def get_connection():
    return psycopg2.connect(
        host=os.getenv("DW_HOST", "localhost"),
        port=os.getenv("DW_PORT", "5432"),  # host port
        dbname=os.getenv("DW_DB", "de_dw"),
        user=os.getenv("DW_USER", "de_user"),
        password=os.getenv("DW_PASSWORD", "de_pass"),
    )
