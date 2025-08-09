# Architecture

This document summarizes the app architecture and key components discovered in the codebase.

## Backend

- Ruby on Rails monolith
- Models encapsulate business logic (fat models, skinny controllers)
- Hotwire (Turbo/Stimulus) with ViewComponents for UI
- Monetizable concerns wrap Money fields; multi-currency support
- Background jobs with Sidekiq; cron via sidekiq-cron
- OAuth via Doorkeeper; sessions for web auth; optional MFA

## Notable Models and Responsibilities

- Family: tenant scope; owns users, accounts, categories, entries, imports, budgets
- Account: delegated types for kinds; entries ledger; holds balance and holdings
- Entry: ledger row for Transaction/Trade/Valuation; carries amount/date/currency
- Transaction: categorized cash flow; tags, merchants; kinds for transfer semantics
- Category: two-level income/expense taxonomy; colors/icons
- BalanceSheet: aggregates accounts into assets/liabilities; net worth + series
- IncomeStatement: aggregates transactions; totals by category + medians/averages
- Budget: monthly, per family; syncs budget categories; alloc/actual/spend metrics
- BudgetCategory: per-category budget data with helpers for overage/segments
- Import (+ subclasses): CSV import pipeline with mapping and publishing
- Chat/Message/Assistant: AI assistant orchestration and provider abstraction

## UI Composition

- Components in `app/components/DS` implement design system (dialogs, tabs, links)
- Tailwind-based tokens and utility classes
- Turbo + Stimulus for interactions; server-side rendering for data

## Data Flow Diagrams

### Domain overview

```mermaid
erDiagram
  FAMILY ||--o{ USER : has
  FAMILY ||--o{ ACCOUNT : has
  FAMILY ||--o{ CATEGORY : has
  FAMILY ||--o{ IMPORT : has
  FAMILY ||--o{ BUDGET : has

  ACCOUNT ||--o{ ENTRY : has
  ENTRY ||--|| TRANSACTION : "entryable"
  ENTRY ||--|| TRADE : "entryable"
  ENTRY ||--|| VALUATION : "entryable"

  CATEGORY ||--o{ TRANSACTION : categorizes
  BUDGET ||--o{ BUDGET_CATEGORY : has
  CATEGORY ||--o{ BUDGET_CATEGORY : for
```

### Dashboard data

```mermaid
flowchart TD
  family-->balance_sheet-->net_worth_series
  family-->income_statement
  income_statement-->income_totals
  income_statement-->expense_totals
  income_totals & expense_totals --> sankey[[Cashflow Sankey]]
```
