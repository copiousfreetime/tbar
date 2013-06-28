# Structure of a transaction

## Top level accounts
* Asset
* Liability
* Equity - these may be the same
* Income - these may be the same
* Expenses

- look at accounting book, find definitive top level rules on the algorithm used
  for cash flow - balance sheet - profit and loss statement.

## Transaction
* Date
* Payee / Description
* State (cleared, pending, uncleared)
* Note
* Tags
* Metadata

### Posting - transaction has at least two postings
* Account 
* Credit/Debit
* Amount
* Commodity (typically USD$)
* Note
* State
* Tags
* Metadata

## Account
* Number
* Name

- dealing with tree structure. Initially, this can be just parent account, and
  then we calculate a flat table for rollup purposes.

###  Payee identification
- when importing new items, we can use the payee information to attempt to
  automatically figure out which of the accounts each side is from based upon
  the postings
