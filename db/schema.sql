-- Payee table

CREATE TABLE IF NOT EXISTS accounts(
  id   SERIAL PRIMARY KEY,
  name text    NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS payees(
  id          SERIAL PRIMARY KEY,
  account_id  integer NOT NULL REFERENCES accounts(id),
  name        text    NOT NULL UNIQUE
);

-- Used for the jaro winkler testing
CREATE TABLE IF NOT EXISTS to_payees(
  id          SERIAL PRIMARY KEY,
  payee_id    integer NOT NULL REFERENCES payees(id),
  description text    NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
  id        SERIAL PRIMARY KEY,
  payee_id  integer NOT NULL REFERENCES payees(id),
  date      date    NOT NULL,
  note      text
);

CREATE TABLE IF NOT EXISTS entries (
  id              SERIAL PRIMARY KEY,
  account_id      integer NOT NULL REFERENCES accounts(id),
  transaction_id  integer NOT NULL REFERENCES transactions(id),
  comodity        text    NOT NULL DEFAULT 'USD',
  amount          integer NOT NULL,
  type            text    NOT NULL CHECK (type IN ('debit', 'credit')),
  note            text
);
