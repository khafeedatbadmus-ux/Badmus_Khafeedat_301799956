-- Bank / Fintech Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."account" (
  "account_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "account_number" text NOT NULL,
  "currency" text NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  "opened_at" date NOT NULL,
  CONSTRAINT "pk_account" PRIMARY KEY ("account_id"),
  CONSTRAINT "uq_account_0" UNIQUE ("account_number")
);
CREATE TABLE portfolio."payment" (
  "payment_id" bigint NOT NULL,
  "account_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "direction" text NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "idempotency_key" text,
  "channel" text NOT NULL,
  CONSTRAINT "pk_payment" PRIMARY KEY ("payment_id")
);
ALTER TABLE portfolio."account" ADD CONSTRAINT "fk_account_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."payment" ADD CONSTRAINT "fk_payment_0" FOREIGN KEY ("account_id") REFERENCES portfolio."account" ("account_id");
ALTER TABLE portfolio."account" ADD CONSTRAINT "account_balance_nonnegative" CHECK ("balance" >= 0);
ALTER TABLE portfolio."payment" ADD CONSTRAINT "payment_positive_amount" CHECK ("amount" > 0);
CREATE UNIQUE INDEX "payment_idempotency_unique" ON portfolio."payment" ("idempotency_key") WHERE ("idempotency_key" IS NOT NULL);
COMMIT;
