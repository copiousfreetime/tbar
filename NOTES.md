# General Accounting Notes

* http://en.wikipedia.org/wiki/Double-entry_bookkeeping_system
* http://en.wikipedia.org/wiki/Debits_and_credits

This approach is also called the American approach. Under this approach
transactions are recorded based on the accounting equation, i.e., Assets =
Liabilities + Capital.[12] The accounting equation is a statement of equality
between the debits and the credits. The rules of debit and credit depend on the
nature of an account. For the purpose of the accounting equation approach, all
the accounts are classified into the following five types:

* assets
* liabilities
* income/revenue
* expenses
* equity/capital

|                | Increase | Decrease |
|----------------|----------|----------|
| Asset          | Debit    | Credit   |
| Liability      | Credit   | Debit    |
| Income/Revenue | Credit   | Debit    |
| Expense        | Debit    | Credit   |
| Equity/Capital | Credit   | Debit    |

# Equations

* Assets = Liabilities + Capital(Equity)
* Equity = Assets - Liabilities
* Assets + Expenses = Equity + Liabilities + Revenue


## Asset
An asset is a resource controlled by the entity as a result of past events or
transactions and from which future economic benefits are expected to flow to the
entity.

Cash, bank, accounts receivable, inventory, land, buildings/plant, machinery,
furniture, equipment, vehicles, trademarks and patents, goodwill, prepaid
expenses, debtors (people who owe us money), etc.

## Liability

Accounts payable, salaries and wages payable, income taxes, bank overdrafts,
trust accounts, accrued expenses, sales taxes, advance payments (unearned
revenue), debt and accrued interest on debt, etc.

All accounts in this subsection are 'payable'

## Equity

Capital, drawings, common stock, accumulated funds, etc.

## Income/Revenue

Services rendered, sales, interest income, membership fees, rent income,
interest from investment, recurring receivables, etc.

## Expense

Telephone, water, electricity, repairs, salaries, wages, depreciation, bad
debts, stationery, entertainment, honorarium, rent, fuel, etc.


1. What is the value of the transaction in terms of dollars (how much money changed
   hands)?
2. Where did the money go - What was gained or paid for by the exchange?
3. Where did the money come from - what is the source of the money in this
   exchange?

# Structure of a transaction

## Top level accounts
* Asset
* Liability
* Equity
* Revenue
* Expenses

- look at accounting book, find definitive top level rules on the algorithm used
  for cash flow - balance sheet - profit and loss statement.

## Transaction - group of postings
* Date
* Payee / Description - entitiy external to the charts owner that is part of the
  transaction
* State (cleared, pending, uncleared)
* Note
* Tags
* Metadata
* type - invoice, bill, payment, purchase, deposit, transfer

### Entry - transaction has at least two postings
* Account
* Credit/Debit
* Amount
* Commodity (typically USD$)
* Note
* State - what is this? Closed or not?
* Tags
* Metadata

## Commodity
* symbol
* Description
* conversion from posting amount ( / 100 )
* type (Currency, Stock)

## Account
* Number
* Name / Description
* Type - Asset, Liability, Equity, Expenese, Revenue
* Cash Account Y/N
* Balance Sheet Account Y/N - mutual exclusive with P&L account
* Profit & Loss Account Y/N

- dealing with tree structure. Initially, this can be just parent account, and
  then we calculate a flat table for rollup purposes.

### Payee identification
- when importing new items, we can use the payee information to attempt to
  automatically figure out which of the accounts each side is from based upon
  the postings

# Reports

## Balance Sheet
* sum of debit balance sheet accounts = sum of credit balance sheet accounts
* Assets = Liability + Equity

## Profit & Loss
* sum of Revenues vs Expenses
* breakdown of debit

## Cash Flow
* evaluate from cash accounts - broken down by where the transaction went

