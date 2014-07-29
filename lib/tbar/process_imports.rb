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
      pn = PayeeNormalization.new( db )
      pn.call
    end

    private 

    def load_chart_of_accounts
      Tbar::ChartOfAccounts.new.tap do |chart|
        db[:accounts].select(:name).each do |row|
          chart.add_account( row[:name] )
        end
      end
    end
  end
end
__END__
    def xcall
      imports.each do |import|
        import_rows( import ).each do |row|
          db.transaction do
            payee   = guess_payee( row[:note] )
            payee   = ask("#{row[:note]} -- Payee ?") { |q| q.default = payee }
            account = db[:accounts].join( :payees, :account_id => :id ).where( :name => payee ).first
            if account.nil? then
              account = ask("Account? ")
              account = db[:accounts][:name => account]
            end
            if payee = db[:payees][:name => row[:note]] then
              payee.update( :account_id => account[:id] )
            else
              db[:payees].insert( :name => row[:note], :account_id => account[:id] )
            end
            db[:import_rows][:id => row[:id]].update( :converted => true )
          end
        end
      end
    end

    private

    def guess_payee( name )
      guesses = []
      db[:payees].each do |row|
        row[:score] = jw.score( row[:name]
      end
    end

    def imports
      db[:imports].select(:id, :account_name).to_enum
    end

    def import_rows( import )
      db[:import_rows].where( :import_id => import[:id], :converted => false ).select( :id, :date, :note, :amount )
    end

  end
end
