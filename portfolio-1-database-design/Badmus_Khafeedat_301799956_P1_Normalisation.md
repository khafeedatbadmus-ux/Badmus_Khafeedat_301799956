# Bank / Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | payment records (list) |
| --- | --- |
| 201 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| payment.payment_id | payment.account_id | payment.direction | account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | debit | 201 | 101 | SYNTH-ACCOUNT-201 | 101 | customer101@example.test |

Key: payment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## payment_example

| payment.payment_id | payment.account_id | payment.direction | account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | debit | 201 | 101 | SYNTH-ACCOUNT-201 | 101 | customer101@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | email | created_at |
| --- | --- | --- |
| 101 | customer101@example.test | 2025-01-10T09:00:00+00:00 |

## account

| account_id | customer_id | account_number | currency | balance | status | opened_at |
| --- | --- | --- | --- | --- | --- | --- |
| 201 | 101 | SYNTH-ACCOUNT-201 | USD | 75.5 | active | 2025-01-11 |

## payment

| payment_id | account_id | amount | direction | occurred_at | status | idempotency_key | channel |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | 24.5 | debit | 2025-01-12T10:30:00+00:00 | settled | synthetic-payment-301 | online |

## Dependencies

- customer: (customer_id) → email, created_at
- account: (account_id) → customer_id, account_number, currency, balance, status, opened_at
- payment: (payment_id) → account_id, amount, direction, occurred_at, status, idempotency_key, channel

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
