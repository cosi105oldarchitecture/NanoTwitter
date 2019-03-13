namespace :db do
  desc 'creates SQL dump from current db'
  task :dump do
    system "#{ENV['CREATE_DUMP']} #{ENV['PG_DUMP_FILE']} #{ENV['PGDATABASE']}"
    puts 'Created SQL dump.'
  end

  namespace :dump do
    desc 'loads db from SQL dump'
    task load: ['db:drop', 'db:create'] do
      system "#{ENV['LOAD_DUMP']} #{ENV['PG_DUMP_FILE']}"
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
      puts 'Loaded database from SQL dump.'
    end
  end
end
