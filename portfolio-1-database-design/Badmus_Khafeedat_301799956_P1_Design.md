# Bank / Fintech Platform — database design

My case study records customer, account, payment.

## Users

- Bank operations analysts
- Fintech application developers
- Database students

## Main operations

- Register customers and accounts
- Record account payments
- Review payment activity and customer totals

## Entities

| Entity | Information stored |
| --- | --- |
| customer | Represents a synthetic customer who may own one or more accounts. |
| account | Represents a customer account with a stored balance, currency, and lifecycle status. |
| payment | Represents a debit or credit recorded against one account; account-owned attributes remain in Account. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| currency | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| opened_at | DATE |  | Yes |
- customer_id → customer.customer_id
- Unique key: (account_number).

## payment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| direction | TEXT |  | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| idempotency_key | TEXT |  | No |
| channel | TEXT |  | Yes |
- account_id → account.account_id

## Relationships and business rules

- Every customer must have an email address.
- A customer email address identifies at most one customer.
- Every account must reference an existing customer through customer_id.
- An account balance must be at least zero after every committed update.
- A payment amount must be greater than zero.
- A non-null idempotency key may identify at most one payment; null keys are excluded from this uniqueness rule.
- Every payment must reference an existing account through account_id.

## Assumptions

- Each account belongs to one customer, and each payment belongs to one account.
- Payments are account-level debits or credits; transfers between accounts, card details, and settlement with external institutions are out of scope.
- Account balance is stored and must remain nonnegative; posting a debit or credit updates it atomically with the payment record.
- Worked normalization example: Payment is the root entity with an account_id foreign key. Keep customer_id, account_number, and currency in Account rather than repeating those account and ancestor attributes in Payment.
- A non-null payment idempotency key is unique; a null key is permitted for payments without a supplied key.
- All benchmark records and event payloads are synthetic.

