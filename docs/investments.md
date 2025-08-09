# Investments

Trades, holdings, and valuations.

## Model

- Entry is polymorphic to Trade or Valuation for investment accounts
- Holdings aggregate positions by security and lot method (FIFO by default)
- Prices sourced from provider (e.g., Plaid) or fallback quote APIs

## Calculations

- Forward calculator: apply trades in chronological order to compute lots and cost basis
- Reverse calculator: compute realized gains for a sell by matching prior lots
- Portfolio cache: daily snapshot of market value per account and family

```mermaid
sequenceDiagram
  participant C as Calculator
  participant H as Holdings
  participant P as Prices
  C->>H: iterate trades chronologically
  H->>H: open/close lots
  C->>P: lookup price for date
  P-->>C: price
  C-->>H: update market value
```

## Reports

- Positions table with quantity, cost basis, market value, unrealized gain
- Realized gains report by period and security
