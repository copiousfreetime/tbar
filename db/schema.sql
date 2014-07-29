-- Payee table

CREATE TABLE IF NOT EXISTS accounts(
  id   integer PRIMARY KEY,
  name text    NOT NULL
);

CREATE TABLE IF NOT EXISTS payees(
  id          integer PRIMARY KEY,
  account_id  integer NOT NULL REFERENCES accounts(id),
  name        text    NOT NULL
);

-- Used for the jaro winkler testing
CREATE TABLE IF NOT EXISTS to_payees(
  id          integer PRIMARY KEY,
  payee_id    integer NOT NULL REFERENCES payees(id),
  description text    NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
  id        integer PRIMARY KEY,
  payee_id  integer NOT NULL REFERENCES payees(id),
  date      date    NOT NULL,
  note      text
);

CREATE TABLE IF NOT EXISTS entries (
  id              integer PRIMARY KEY,
  account_id      integer NOT NULL REFERENCES accounts(id),
  transaction_id  integer NOT NULL REFERENCES transactions(id),
  comodity        text    NOT NULL DEFAULT 'USD',
  amount          integer NOT NULL,
  type            text    NOT NULL CHECK (type IN ('debit', 'credit')),
  note            text
);
