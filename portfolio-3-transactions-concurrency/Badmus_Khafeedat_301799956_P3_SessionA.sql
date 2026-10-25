-- Use two psql terminals connected to the same exercise database.
-- Follow the numbered order across Session A and Session B.

-- 1. Session A: read 1.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "account_id", "p3_processed_count" FROM portfolio."account" WHERE "account_id" IS NOT DISTINCT FROM 201;

-- 3. Session A: write the value calculated from its earlier read.
UPDATE portfolio."account" SET "p3_processed_count" = 2 WHERE "account_id" IS NOT DISTINCT FROM 201 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;

-- 5. Reset for an equal starting point. Run outside both transactions.
UPDATE portfolio."account" SET "p3_processed_count" = 1 WHERE "account_id" IS NOT DISTINCT FROM 201 RETURNING json_build_object('processed_count',"p3_processed_count");

-- 6. Session A: lock the row before reading.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "account_id", "p3_processed_count" FROM portfolio."account" WHERE "account_id" IS NOT DISTINCT FROM 201 FOR UPDATE;

-- 8. Session A: update and release the lock by committing.
UPDATE portfolio."account" SET "p3_processed_count" = 2 WHERE "account_id" IS NOT DISTINCT FROM 201 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
