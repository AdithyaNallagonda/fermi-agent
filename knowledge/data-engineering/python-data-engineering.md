# Python for Data Engineering
Last reviewed: 2026-10 — Python **3.14** current (3.14.8, Sep 2026; free-threaded build officially supported,
t-strings, deferred annotations); 3.15 due Oct 2026; 3.9 EOL Oct 2025. Pin runtimes supported by Glue/EMR/Lambda.

## Toolchain (modern defaults)
- Env & packaging: **uv** (fast installer/resolver, lockfiles), pyproject.toml, ruff (lint/format), mypy/
  pyright (types), pre-commit, pytest.
- DataFrames: **Polars** (Rust, lazy, multithreaded, fast for single-node up to ~100s of GB with
  streaming), pandas 2.x (PyArrow backend), **DuckDB** (SQL on Parquet/CSV in-process), **PyArrow**
  (columnar memory, Parquet I/O, Arrow Flight), PySpark (distributed), Dask/Ray (parallel Python).
- I/O: fsspec/s3fs, boto3 (AWS), adlfs (Azure), gcsfs, SQLAlchemy 2.x, ConnectorX/ADBC for fast DB reads.
- Validation: Pydantic v2, Pandera, Great Expectations, Soda.
- Table formats: PyIceberg, delta-rs (deltalake).
- Orchestration clients: Airflow, Dagster, Prefect.

## Choosing compute
| Data size / need | Tool |
|---|---|
| < few GB, ad hoc | pandas / Polars / DuckDB |
| GBs–~100s GB single node | Polars lazy/streaming, DuckDB |
| TBs, joins/shuffles across cluster | Spark (Glue/EMR/Databricks/Dataproc) |
| Streaming | Flink (PyFlink), Spark Structured Streaming, Kafka Streams (JVM), Bytewax |
| Python-native parallel / ML | Ray |

## Engineering practices
- Idempotent, re-runnable jobs (partition overwrite, MERGE/upsert, deterministic outputs).
- Parameterize by logical date; support backfills.
- Schema contracts and evolution handling; fail fast on breaking changes.
- Unit-test transformations as pure functions (pytest + small fixtures; local Spark session `local[2]`;
  chispa for DataFrame asserts); integration tests on sample data; data quality checks in pipeline.
- Logging with structured context; metrics (rows in/out, durations, nulls).
- Memory: read only needed columns (Parquet projection), filter early (predicate pushdown), chunk/stream
  large files, use categorical/Arrow dtypes.
- Packaging for Glue/EMR: wheels, `--additional-python-modules`, virtualenv-in-archive for EMR Serverless.

## Performance tips
Vectorize (no row-wise `apply`), Polars expressions, Arrow-backed dtypes, avoid Python UDFs in Spark
(use built-ins or pandas UDFs/Arrow), multiprocessing for CPU-bound (until free-threading is mainstream),
asyncio for I/O-bound API ingestion with rate limits and retries (tenacity).

## Sample: idempotent daily partition write (Polars → S3 Parquet)
```python
import polars as pl

def transform(df: pl.LazyFrame) -> pl.LazyFrame:
    return (df.filter(pl.col("status") == "COMPLETED")
              .with_columns(pl.col("amount").cast(pl.Decimal(18, 2)))
              .group_by("customer_id").agg(pl.col("amount").sum().alias("total")))

def run(ds: str, src: str, dst: str) -> None:
    out = transform(pl.scan_parquet(f"{src}/dt={ds}/*.parquet")).collect()
    out.write_parquet(f"{dst}/dt={ds}/part-0.parquet")  # overwrite partition → idempotent
```

## Interview angles
pandas vs Polars vs Spark choice; making pipelines idempotent; handling late-arriving data; testing
data pipelines.
