namespace :db do
  desc 'Creates a SQL dump file from the database'
  task :dump do
    system "#{ENV['CREATE_DUMP']} #{ENV['PG_DUMP_FILE']} #{ENV['PGDATABASE']}"
    puts 'Created SQL dump.'
  end

  namespace :dump do
    desc 'Loads the database from a SQL dump file'
    task load: ['db:drop', 'db:create'] do
      system "psql -f #{ENV['PG_DUMP_FILE']} #{ENV['PG_HOST']}"
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
      puts 'Loaded database from SQL dump.'
    end
  end
end
