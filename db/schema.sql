-- Payee table

CREATE TABLE IF NOT EXISTS accounts(
  id   integer PRIMARY KEY,
  name text    NOT NULL
);

CREATE TABLE IF NOT EXISTS payees(
  id          integer PRIMARY KEY,
  name        text    NOT NULL,
  account_id  integer NOT NULL REFERENCES accounts(id)
);

CREATE TABLE IF NOT EXISTS transactions (
  id        integer PRIMARY KEY,
  date      date    NOT NULL,
  payee_id  integer NOT NULL REFERENCES payees(id),
  note      text
);

CREATE TABLE IF NOT EXISTS entries (
  id              integer primary key,
  account_id      integer REFERENCES accounts(id),
  transaction_id  integer REFERENCES transactions(id),
  comodity        text    NOT NULL DEFAULT 'USD',
  amount          integer NOT NULL,
  note            text,
  type            text    NOT NULL CHECK (type IN ('debit', 'credit'))
);
