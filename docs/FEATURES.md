# Feature Matrix

A concise list of user-facing features and where to look in code.

- Dashboard
  - Balance sheet with net worth sparkline: `PagesController#dashboard`, `BalanceSheet`
  - Cashflow Sankey: `PagesController#dashboard#build_cashflow_sankey_data`, `IncomeStatement`
- Accounts
  - CRUD and sync: `AccountsController`, `Account`, `Syncable`
  - Sparklines: `AccountableSparklinesController`
- Transactions
  - Search/filter/pagination: `TransactionsController#index`, `Transaction::Search`
  - Bulk update/delete: `Transactions::BulkUpdate`, `Transactions::BulkDeletion`
  - Rules and auto-categorization: `Rule`, `AutoCategorizeJob`
- Transfers
  - Auto-match and manual linking: `Transfer`, `Family::AutoTransferMatchable`, `TransferMatchesController` ([docs](transfers.md))
- Categories
  - Bootstrap defaults: `Category.bootstrap!`
  - Two-level hierarchy, color/icon: `Category`
- Budgets
  - Monthly budgets, allocations, donut: `Budget`, `BudgetCategory`, views in `app/views/budgets`
- Imports
  - CSV pipeline: `Import`, `ImportJob`, `RevertImportJob`, controllers in `app/controllers/import`
- Sync
  - Family/item/account syncers, webhooks: `Sync`, `AccountSyncer`, `FamilySyncer`, `PlaidItemSyncer`, `Provider::Plaid` ([docs](sync.md))
- AI
  - Chat, streaming, tools: `Chat`, `Message`, `Assistant`, `AssistantResponseJob`
- Tags & Merchants
  - Tagging, merges, merchant detection: `Tag`, `Merchant`, rules actions ([docs](tags-and-merchants.md))
- Investments
  - Trades, holdings, valuations, reports: `Trade`, `Holding`, calculators, portfolio cache ([docs](investments.md))
- Exchange Rates
  - Providers and importer for FX: `ExchangeRate::Provider`, `ExchangeRate::Importer`, `Money.exchange_to` ([docs](exchange-rates.md))
- Settings
  - Preferences, security, billing: `settings/*`
- Security & Auth
  - Sessions, MFA, OAuth via Doorkeeper: `SessionsController`, MFA controllers, `config/initializers/doorkeeper.rb` ([docs](security-auth.md))
- API
  - OAuth + Chat API: `config/routes.rb` under `/api/v1`, `docs/api/chats.md`
