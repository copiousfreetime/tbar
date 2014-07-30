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

    def build_transactions
      imports.each_with_index do |import,import_idx|
        puts "Importing associated rows from #{import[:path]}"
        import_rows( import ).each_with_index do |row,row_idx|
          db.transaction do
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
            else
              #puts "Skipping #{row.inspect} for now"
              next
            end
          end
        end
      end
    end

    private


    def account_prompt( prompt )
      new_name = nil
      choose do |menu|
        menu.index  = :number
        menu.prompt = prompt
        by_name     = chart.accounts_by_name
        menu.choices( *by_name.keys.sort.map { |s| s.strip } ) do |name|
          puts "Using #{name} instead"
          new_name = name
        end
       menu.flow   = :columns_down
      end
      return new_name
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
