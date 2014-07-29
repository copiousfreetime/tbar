require 'csv'
require 'monetize'
require 'digest'
require 'pathname'

module Tbar
  class CsvImport
    attr_reader :from
    attr_reader :db
    attr_reader :account
    attr_reader :chart

    def initialize( kwargs = {} )
      @db           = kwargs.fetch( :db )
      @chart        = load_chart_of_accounts()
      @account_name = kwargs.fetch( :account )
      @account      = chart.accounts_by_name[ kwargs.fetch( :account ) ]
      @from         = Pathname.new( kwargs.fetch( :from ) ).realpath
      @date_field   = kwargs.fetch( :date_field )
      @note_field   = kwargs.fetch( :note_field )
      @amount_field = kwargs.fetch( :amount_field )

      validate
    end

    def call
      insert_import_record
    end

    private

    def validate
      raise ArgumentError, "file #{from} does not exist" unless from.exist?
      raise ArgumentError, "account #{@account_name} does not exist in the chart of accounts" unless account
    end

    def insert_import_record
      puts "importing #{@from.size} bytes from #{@from}"
      db.transaction do
        import_id = db[:imports].insert( :path         => @from.to_s,
                                         :sha256       => Digest::SHA256.file(@from.to_s).hexdigest,
                                         :date_field   => @date_field,
                                         :note_field   => @note_field,
                                         :amount_field => @amount_field,
                                         :byte_count   => @from.size,
                                         :content      => @from.read )

        row_idx = 0
        CSV.foreach( @from, :headers => :first_row, :return_headers => false  ) do |row|
          db[:import_rows].insert( :import_id => import_id,
                                   :row_index => row_idx,
                                   :date      => row[@date_field],
                                   :note      => row[@note_field],
                                   :amount    => row[@amount_field],
                                   :content   => row.to_s,
                                 )
          row_idx += 1
        end
      end
    end

    def load_chart_of_accounts
      Tbar::ChartOfAccounts.new.tap do |chart|
        db[:accounts].select(:name).each do |row|
          chart.add_account( row[:name] )
        end
      end
    end
  end
end
