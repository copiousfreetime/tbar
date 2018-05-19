require 'highline/import'
module Tbar
  class ProcessImports

    attr_reader :db
    attr_reader :chart

    def initialize( db )
      @db    = db
      @chart = load_chart_of_accounts
      @jw    = JaroWinkler.new
    end

    def call
      normalize_payees
      process_deposits
      process_transfers
      build_transactions
    end

    private 

    def normalize_payees
      pn = PayeeNormalization.new( db )
      pn.call
    end

    def load_chart_of_accounts
      Tbar::ChartOfAccounts.new.tap do |chart|
        db[:accounts].select(:name).each do |row|
          chart.add_account( row[:name] )
        end
      end
    end

    def process_transfers
      puts "Processing transfer entries"
      skipping = []
      next_transfer_rows.each do |row|
        next if skipping.include?( row[:row_id] )
        puts "#{row[:row_id]} -- #{row[:date]} -- #{row[:amount]} -- #{row[:account_name]}"
        puts "  #{row[:note]}"
        other_row = nil

        choose do |menu|
          menu.index  = :number
          menu.prompt = "What is the other side of this transaction"
          next_rows = next_transfer_rows(8, row[:amount]).to_a
          puts "Got rows #{next_rows.size}"

          next_rows.each do |option|
            next if option[:row_id] == row[:row_id]
            s = "#{option[:row_id]} - #{option[:date]} - #{option[:amount]} - #{option[:account_name]} - #{option[:note]}"
            menu.choice( s ) do |r|
              other_row = option
            end
          end
          menu.choice( "Skip" ) { |r| skipping << row[:row_id] ; other_row = nil }
        end

        next unless other_row

        txn = create_txn_from_rows( row, other_row )
        puts txn.to_s
        if agree( "Does this transaction look good? " ) then
          payee  = db[:payees][ :name => 'Transfer' ]
          txn_id = db[:transactions].insert( :payee_id => payee[:id], :note => txn.note, :date => txn.date )
          txn.entries.each do |entry|
            account_id = db[:accounts][ :name => entry.account.real_name ][:id]
            entry_id   = db[:entries].insert( :transaction_id => txn_id, :account_id => account_id,
                                   :amount => entry.amount.cents, :note => entry.note,
                                   :type   => entry.type.to_s )
            row_id = case entry.note
                     when row[:note]
                       row[:row_id]
                     when other_row[:note]
                       other_row[:row_id]
                     else
                       raise ArgumentError, "Unable to find row matching #{entry.note}"
                     end
            db[:import_rows].where( :id => row_id ).update( :entry_id => entry_id )
          end
        else
          puts "Okay, we'll come back to it later"
        end
      end
    end

    def process_deposits
      imports.each do |import|
        puts "Importing deposit rows from #{import[:path]}"
        deposit_rows( import ).each do |row|
          my_account    = account_for_name( import[:account_name] )
          my_entry      = my_account.entry_for( Monetize.parse(row[:amount]) )
          puts row[:date]
          puts my_entry
          puts "  #{row[:note]}"
          their_account_name = account_prompt( "Which Account should be on the other side?" )
          their_account      = account_for_name( their_account_name )
          their_entry        = my_entry.paired_entry( their_account, row[:note] )
          txn = Transaction.new( :entries => [my_entry, their_entry],
                                 :date    => Date.parse( row[:date] ),
                                 :payee   => 'Deposit')
          validate_and_store_transaction( txn, row )
        end
      end
    end

    def build_transactions
      imports.each_with_index do |import,import_idx|
        puts "Importing associated rows from #{import[:path]}"
        import_rows( import ).each_with_index do |row,row_idx|
          payee   = db[:payees][ :id => row[:payee_id] ]
          if payee[:associated] then
            my_account    = account_for_name( import[:account_name] )
            other_account = db[:accounts][ :id => payee[:account_id] ]

            # Prompt for confirmation on this account and setup a menu if it
            # isn't
            my_entry    = my_account.entry_for( Monetize.parse(row[:amount]) )
            puts my_entry
            puts "  #{row[:note]}"
            their_account_name = if agree("  Paired Account is: #{other_account[:name]}  ok? ") then
                                   other_account[:name]
                                 else
                                   account_prompt( "Which Account should be on the other side?" )
                                 end

            their_account = account_for_name( their_account_name )
            their_entry    = my_entry.paired_entry( their_account, row[:note] )
            txn = Transaction.new( :entries => [my_entry, their_entry],
                                   :date    => Date.parse( row[:date] ),
                                   :payee   => payee[:name] )
            validate_and_store_transaction( txn,row )
          else
            #puts "Skipping #{row.inspect} for now"
            next
          end
        end
      end
    end

    def validate_and_store_transaction( txn,row )
      db.transaction do
        payee = db[:payees][ :name => txn.payee ]
        if txn.valid? then
          puts txn.to_s
          if agree( "Does this transaction look good? " ) then
            save_txn_to_db( txn, payee, row )
          else
            puts "Okay, we'll come back to it later"
          end
        else
          puts "Transaction is not valid!"
        end
      end
    end

    private


    def account_prompt( prompt, names = chart.accounts_by_name.keys )
      new_name = nil
      choose do |menu|
        menu.index  = :number
        menu.prompt = prompt
        #by_name     = chart.accounts_by_name
        menu.choices( *names.sort.map { |s| s.strip } ) do |name|
          puts "Using #{name} instead"
          new_name = name
        end
       menu.flow   = :columns_down
      end
      return new_name
    end

    def create_txn_from_rows( row1, row2 )
      account1_name  = row1[:account_name]
      account1       = account_for_name( account1_name )
      entry1         = account1.entry_for( Monetize.parse( row1[:amount] ), row1[:note] )

      account2_name  = row2[:account_name]
      account2       = account_for_name( account2_name )
      entry2         = entry1.paired_entry( account2, row2[:note] )

      transfer       = Transaction.new( :entries => [entry1, entry2],
                                        :date   => Date.parse( row1[:date] ),
                                        :payee  => 'Transfer' )
      return transfer
    end

    def save_txn_to_db( txn, payee, row )
      txn_id = db[:transactions].insert( :payee_id => payee[:id], :note => txn.note, :date => txn.date )
      txn.entries.each do |entry|
        account_id = db[:accounts][ :name => entry.account.real_name ][:id]
        entry_id   = db[:entries].insert( :transaction_id => txn_id, :account_id => account_id,
                               :amount => entry.amount.cents, :note => entry.note,
                               :type   => entry.type.to_s )
        db[:import_rows].where( :id => row[:row_id] ).update( :entry_id => entry_id )
      end
    end

    def account_for_name( name )
      chart.accounts_by_name[name]
    end

    def imports
      sql = <<-SQL
        SELECT i.id AS id
              ,i.path as path
              ,a.id AS account_id
              ,a.name AS account_name
              ,count(r.id) AS count
          FROM imports AS i
          JOIN accounts AS a
            ON i.account_name = a.name
          JOIN import_rows AS r
            ON r.import_id = i.id
      GROUP BY 1,2,3,4
      SQL

      db[sql].to_enum
    end

    def deposit_rows( import )
      payee_rows( import, 'Deposit' )
    end

    def transfer_rows( import )
      payee_rows( import, 'Transfer' )
    end

    def next_transfer_rows( limit = nil, amount = nil )
      sql = <<-SQL
        SELECT row.id      AS row_id
              ,row.date    AS date
              ,row.note    AS note
              ,row.amount  AS amount
              ,to_p.payee_id AS payee_id
              ,i.account_name      AS account_name
         FROM import_rows AS row
         JOIN to_payees   AS to_p
           ON row.note = to_p.description
         JOIN payees      AS p
           ON to_p.payee_id = p.id
         JOIN imports   AS i
           ON i.id = row.import_id
        WHERE p.name = 'Transfer'
          AND row.entry_id IS NULL
      SQL
      if amount then
        amount = amount.tr('-$',' ').strip
        amount = "%#{amount}%"
        sql << "AND row.amount like '#{amount}'"
      end
      sql << "ORDER BY row.date ASC"
      db[sql].limit( limit )
    end

    def transfer_matching_amount( amount )
      wild_amount = "%#{amount}%"
      sql = <<-SQL
        SELECT row.id      AS row_id
              ,row.date    AS date
              ,row.note    AS note
              ,row.amount  AS amount
              ,to_p.payee_id AS payee_id
         FROM import_rows AS row
         JOIN to_payees   AS to_p
           ON row.note = to_p.description
         JOIN payees      AS p
           on to_p.payee_id = p.id
        WHERE row.entry_id IS NULL
          And p.name = 'Transfer'
          AND row.amount ilike ?
      ORDER BY row.date ASC
      SQL
      db[sql, wild_amount ].to_enum
    end

    def payee_rows( import, payee )
      sql = <<-SQL
        SELECT row.id      AS row_id
              ,row.date    AS date
              ,row.note    AS note
              ,row.amount  AS amount
              ,to_p.payee_id AS payee_id
         FROM import_rows AS row
         JOIN to_payees   AS to_p
           ON row.note = to_p.description
         JOIN payees      AS p
           on to_p.payee_id = p.id
        WHERE row.entry_id IS NULL
          AND row.import_id = ?
          And p.name = ?
     ORDER BY row.date ASC
      SQL
      db[sql, import[:id], payee].to_enum
    end

    def import_rows( import )
      sql = <<-SQL
        SELECT row.id      AS row_id
              ,row.date    AS date
              ,row.note    AS note
              ,row.amount  AS amount
              ,to_p.payee_id AS payee_id
         FROM import_rows AS row
         JOIN to_payees   AS to_p
           ON row.note = to_p.description
        WHERE row.entry_id IS NULL
          AND row.import_id = ?
     ORDER BY row.date ASC
      SQL
      db[sql, import[:id]].to_enum
    end
  end
end
