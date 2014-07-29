-- Payee table

CREATE TABLE IF NOT EXISTS accounts(
  id   SERIAL PRIMARY KEY,
  name text   NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS payees(
  id          SERIAL PRIMARY KEY,
  account_id  integer REFERENCES accounts(id),
  associated  boolean NOT NULL DERFAULT true,
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

CREATE TABLE IF NOT EXISTS imports (
  id           SERIAL  PRIMARY KEY,
  account_name text    NOT NULL REFERENCES accounts(name),
  sha256       text    NOT NULL UNIQUE,
  date_field   text    NOT NULL,
  note_field   text    NOT NULL,
  amount_field text    NOT NULL,
  path         text    NOT NULL,
  byte_count   integer NOT NULL,
  content      text    NOT NULL
);

CREATE TABLE IF NOT EXISTS import_rows(
  id        SERIAL  PRIMARY KEY,
  import_id integer NOT NULL REFERENCES imports(id),
  row_index integer NOT NULL,
  date      text    NOT NULL,
  note      text    NOT NULL,
  amount    text    NOT NULL,
  converted boolean NOT NULL DEFAULT false,
  content   text    NOT NULL
);
CREATE UNIQUE INDEX idx_import_lines_on_id_line_idx ON import_rows( import_id, row_index);

