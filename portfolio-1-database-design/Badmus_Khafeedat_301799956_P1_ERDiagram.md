# Bank / Fintech Platform — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text email UK
        timestamptz created_at
    }
    account {
        bigint account_id PK
        bigint customer_id FK
        text account_number UK
        text currency
        numeric balance
        text status
        date opened_at
    }
    payment {
        bigint payment_id PK
        bigint account_id FK
        numeric amount
        text direction
        timestamptz occurred_at
        text status
        text idempotency_key "Optional"
        text channel
    }
    customer ||--o{ account : "customer_id"
    account ||--o{ payment : "account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Badmus_Khafeedat_301799956_ERDiagram.png)
