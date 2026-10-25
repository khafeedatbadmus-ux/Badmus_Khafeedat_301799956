-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk duplicate. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (101, 'customer-pk-test@example.test', '2025-02-01T09:00:00Z');

-- 2. customer email duplicate. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (102, 'customer101@example.test', '2025-02-01T09:00:00Z');

-- 3. customer email null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at")
VALUES (103, NULL, '2025-02-01T09:00:00Z');

-- 4. account pk duplicate. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_at")
VALUES (201, 101, 'SYNTH-ACCOUNT-PK-TEST', 'USD', 10, 'active', '2025-02-01');

-- 5. account number duplicate. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_at")
VALUES (202, 101, 'SYNTH-ACCOUNT-201', 'USD', 10, 'active', '2025-02-01');

-- 6. account customer missing. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_at")
VALUES (203, 999, 'SYNTH-ACCOUNT-FK-TEST', 'USD', 10, 'active', '2025-02-01');

-- 7. account balance negative. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_at")
VALUES (204, 101, 'SYNTH-ACCOUNT-CHECK-TEST', 'USD', -1, 'active', '2025-02-01');

-- 8. payment pk duplicate. Expected: pk_payment, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "direction", "occurred_at", "status", "idempotency_key", "channel")
VALUES (301, 201, 5, 'debit', '2025-02-01T09:00:00Z', 'settled', 'synthetic-payment-pk-test', 'online');

-- 9. payment account missing. Expected: fk_payment_0, SQLSTATE 23503.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "direction", "occurred_at", "status", "idempotency_key", "channel")
VALUES (302, 999, 5, 'debit', '2025-02-01T09:00:00Z', 'settled', 'synthetic-payment-fk-test', 'online');

-- 10. payment amount zero. Expected: payment_positive_amount, SQLSTATE 23514.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "direction", "occurred_at", "status", "idempotency_key", "channel")
VALUES (303, 201, 0, 'debit', '2025-02-01T09:00:00Z', 'settled', 'synthetic-payment-check-test', 'online');

-- 11. payment idempotency duplicate. Expected: payment_idempotency_unique, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "direction", "occurred_at", "status", "idempotency_key", "channel")
VALUES (304, 201, 5, 'debit', '2025-02-01T09:00:00Z', 'settled', 'synthetic-payment-301', 'online');
