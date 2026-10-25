-- Fictional sample records for Bank / Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "email", "created_at") VALUES (101, 'customer101@example.test', '2025-01-10T09:00:00Z');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "status", "opened_at") VALUES (201, 101, 'SYNTH-ACCOUNT-201', 'USD', 75.5, 'active', '2025-01-11');
INSERT INTO portfolio."payment" ("payment_id", "account_id", "amount", "direction", "occurred_at", "status", "idempotency_key", "channel") VALUES (301, 201, 24.5, 'debit', '2025-01-12T10:30:00Z', 'settled', 'synthetic-payment-301', 'online');
COMMIT;
