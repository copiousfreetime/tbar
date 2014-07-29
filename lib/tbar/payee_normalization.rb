require 'tbar/jaro_winkler'
require 'highline/import'
module Tbar
  class PayeeNormalization
    attr_reader :db
    def initialize( db )
      @db = db
      @jw = JaroWinkler.new
    end

    def call
      notes_to_payees
    end

    private

    def notes_to_payees
      db[:import_rows].where( :converted => false ).each do |row|
        to_payee = db[:to_payees][:description => row[:note]]
        next if to_payee

        options = payees_by_score( row[:note] )

        if options.empty? then
          options = %w[ Transfer ]
        end

        choose do |menu|
          menu.index = :number
          menu.prompt = "Looking Which payee for #{row[:date]} #{row[:amount]} #{row[:note]} ?"

          options[31..-1].each do |o|
            menu.hidden( o ) do |v|
              row[:payee_id] = db[:payees][:name => v][:id]
            end
          end
 
          menu.choices( *options[0..30] ) do |name|
            pid = if p = db[:payees][:name => name] then
                    p[:id]
                  else
                    puts "Inserting #{name} into payees"
                    db[:payees].insert( :name => name )
                  end
            row[:payee_id] = pid
          end
          menu.choice "New Payee" do
            p = ask("New Payee? ")
            pid = db[:payees].insert( :name => p )
            row[:payee_id] = pid
          end

       end

        db[:to_payees].insert( :description => row[:note], :payee_id => row[:payee_id] )

      end
    end

    def payees_by_score( val )
      sql = <<-SQL
      SELECT p.name AS name
            ,t.description AS description
       FROM payees AS p
       JOIN to_payees AS t
         ON p.id = t.payee_id
      SQL
      db[ sql ].map do |row|
        row[:score] = @jw.distance( row[:description], val )
        row
      end.sort_by { |r| r[:score] }.reverse.map { |r| r[:name] }.uniq
    end
  end
end
