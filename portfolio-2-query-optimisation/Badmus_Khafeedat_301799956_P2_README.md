# Bank / Fintech Platform — SQL queries

## 1. Show related customer, account, payment records (up to 20).

```sql
SELECT t0."customer_id" AS "customer_customer_id",
       t0."email" AS "customer_email",
       t1."account_id" AS "account_account_id",
       t1."account_number" AS "account_account_number",
       t2."payment_id" AS "payment_payment_id",
       t2."amount" AS "payment_amount"
FROM portfolio."customer" t0
JOIN portfolio."account" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."payment" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."customer_id", t1."account_id", t2."payment_id"
LIMIT 20;
```

| customer_customer_id | customer_email | account_account_id | account_account_number | payment_payment_id | payment_amount |
| --- | --- | --- | --- | --- | --- |
| 101 | customer101@example.test | 201 | SYNTH-ACCOUNT-201 | 301 | 24.5 |

## 2. Find payment records where occurred_at matches "2025-01-12T10:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."payment"
WHERE "occurred_at" IS NOT DISTINCT FROM '2025-01-12T10:30:00Z'
ORDER BY "payment_id"
LIMIT 20;
```

| payment_id | account_id | amount | direction | occurred_at | status | idempotency_key | channel |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | 24.5 | debit | 2025-01-12T10:30:00+00:00 | settled | synthetic-payment-301 | online |

## 3. Count account records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."account"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 101 | 1 |

## 4. Find payment records where occurred_at matches "2025-01-12T10:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."payment"
WHERE "occurred_at" IS NOT DISTINCT FROM '2025-01-12T10:30:00Z'
ORDER BY "payment_id"
LIMIT 20;
```

| payment_id | account_id | amount | direction | occurred_at | status | idempotency_key | channel |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | 24.5 | debit | 2025-01-12T10:30:00+00:00 | settled | synthetic-payment-301 | online |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.455 | 2.413, 1.455, 1.382 | Sort → Seq Scan | 139 |
| After index | 0.318 | 0.318, 0.423, 0.262 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.455 ms to 0.318 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.25..2.252 rows=25 loops=1)
  Seq Scan on payment (actual time=0.017..2.195 rows=25 loops=1)
Planning Time: 0.439 ms
Execution Time: 2.413 ms
```

### Before index, run 2

```text
Sort (actual time=1.421..1.422 rows=25 loops=1)
  Seq Scan on payment (actual time=0.017..1.326 rows=25 loops=1)
Planning Time: 0.476 ms
Execution Time: 1.455 ms
```

### Before index, run 3

```text
Sort (actual time=1.347..1.349 rows=25 loops=1)
  Seq Scan on payment (actual time=0.017..1.274 rows=25 loops=1)
Planning Time: 0.453 ms
Execution Time: 1.382 ms
```

### After index, run 1

```text
Sort (actual time=0.239..0.241 rows=25 loops=1)
  Bitmap Heap Scan on payment (actual time=0.04..0.153 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.023..0.024 rows=25 loops=1)
Planning Time: 0.759 ms
Execution Time: 0.318 ms
```

### After index, run 2

```text
Sort (actual time=0.277..0.279 rows=25 loops=1)
  Bitmap Heap Scan on payment (actual time=0.054..0.196 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.031..0.032 rows=25 loops=1)
Planning Time: 1.193 ms
Execution Time: 0.423 ms
```

### After index, run 3

```text
Sort (actual time=0.191..0.192 rows=25 loops=1)
  Bitmap Heap Scan on payment (actual time=0.037..0.139 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.021..0.021 rows=25 loops=1)
Planning Time: 0.794 ms
Execution Time: 0.262 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Badmus_Khafeedat_301799956_P2_Queries.sql, then Badmus_Khafeedat_301799956_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Badmus_Khafeedat_301799956_P2_QueryResults.png) · [Index comparison](screenshots/Badmus_Khafeedat_301799956_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

