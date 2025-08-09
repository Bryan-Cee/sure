# Domain Model

This page documents the key entities and relationships used across the app.

```mermaid
erDiagram
  FAMILY ||--o{ USER : has
  FAMILY ||--o{ ACCOUNT : has
  FAMILY ||--o{ CATEGORY : has
  FAMILY ||--o{ IMPORT : has
  FAMILY ||--o{ BUDGET : has
  FAMILY ||--o{ MERCHANT : has
  FAMILY ||--o{ RULE : has

  ACCOUNT ||--o{ ENTRY : has
  ENTRY ||--|| TRANSACTION : entryable
  ENTRY ||--|| TRADE : entryable
  ENTRY ||--|| VALUATION : entryable

  CATEGORY ||--o{ TRANSACTION : categorizes
  TRANSACTION }o--o{ TAG : tags
  TRANSACTION }o--o{ MERCHANT : merchant

  BUDGET ||--o{ BUDGET_CATEGORY : has
  CATEGORY ||--o{ BUDGET_CATEGORY : for
  CATEGORY ||--o{ CATEGORY : subcategories
```

Notes:

- Entries are the ledger rows that carry amount, date, and currency, and belong to an account. Transactions/Trades/Valuations are entryable types.
- Categories have at most two levels (parent -> subcategory); classification is income or expense.
- Budget categories mirror the family's expense categories for a given month.
