namespace :db do
  desc 'Creates a SQL dump file from the database'
  task :copy_gem_migrations do
    migrate_dir = 'db/migrate'
    FileUtils.remove_dir(migrate_dir) if File.directory?(migrate_dir)
    FileUtils.mkdir(migrate_dir)
    FileUtils.copy_entry("#{`gem path nt_models`.gsub("\n", ''
)}/#{migrate_dir}", migrate_dir)
  end

  task migrate: :copy_gem_migrations
end
