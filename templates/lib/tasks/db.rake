namespace :db do
  desc "Reset everything for local development"
  task :reborn do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:data:load"].invoke
  end
end
