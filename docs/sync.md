# Sync

Periodic ingestion of transactions, balances, and investment data.

## Entities

- Sync: tracks a run (`pending`, `running`, `failed`, `succeeded`) and duration, error, counts.
- Syncers: service objects that perform work
  - AccountSyncer: pulls transactions/balances for a single account
  - FamilySyncer: orchestrates all accounts in a family
  - PlaidItemSyncer: refreshes access tokens, pulls accounts and transactions, handles webhooks
- Providers
  - Plaid provider implements account discovery, transactions, balances, and investments

## Flow

```mermaid
sequenceDiagram
  participant U as User
  participant FS as FamilySyncer
  participant AS as AccountSyncer
  participant P as Plaid
  U->>FS: Start sync
  FS->>AS: for each linked account
  AS->>P: fetch transactions and balances
  P-->>AS: account snapshots + txn pages
  AS->>AS: dedupe, upsert, attach merchants
  AS->>AS: auto-categorize, apply rules
  AS->>FS: report counts
  FS-->>U: Sync complete
```

## Plaid webhooks

- Item webhook: schedules a refresh run for the affected item
- Transactions webhook: schedules a targeted backfill
- Holdings/Investments webhook: refresh positions and prices

## Failure handling

- Retries with exponential backoff for provider errors
- Partial success recorded on the Sync record; follow-up runs continue from cursors
