def load_dump(file)
  system "psql -f #{ENV['PG_DUMP_PATH']}/#{file} #{ENV['PG_HOST']}"
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
  puts "Loaded database from #{file}."
end

namespace :db do
  desc 'Creates a SQL dump file from the database'
  task :dump do
    system "pg_dump #{ENV['PG_HOST']} -f #{ENV['PG_DUMP_PATH']}/#{ENV['PG_DUMP_FILE']}"
    puts 'Created SQL dump.'
  end

  namespace :dump do
    desc 'Loads the database from a SQL dump file'
    task load: ['db:drop', 'db:create'] do
      load_dump(ENV['PG_DUMP_FILE'])
    end

    desc 'Loads the database from a SQL dump file'
    task seed: ['db:drop', 'db:create'] do
      load_dump("seed_#{ENV['PG_DUMP_FILE']}")
    end
  end
end
