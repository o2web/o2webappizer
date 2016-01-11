require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module O2webappizer
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: false,
      desc: "Don't run bundle install"

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    class_option :force, type: :boolean, aliases: "-f", default: true,
      desc: "Overwrite files that already exist"

    class_option :solidus, type: :boolean, default: true,
      desc: "Install Solidus as well"

    class_option :locales, type: :array, default: ['fr', 'en'],
      desc: "Available locales (default locale comes first)"

    class_option :migrate, type: :boolean, default: true,
      desc: 'Run migrations'

    class_option :seed, type: :boolean, default: true,
      desc: 'load seed data (migrations must be run)'

    class_option :sample, type: :boolean, default: true,
      desc: 'load sample data (migrations must be run)'

    class_option :drop, type: :boolean, default: false,
      desc: 'Drop current table before migration'

    class_option :auto_accept, type: :boolean, default: true,
      desc: 'Auto-accept prompts'

    class_option :admin_email, type: :string,
      desc: 'Admin email'

    class_option :admin_password, type: :string,
      desc: 'Admin password'

    class_option :ruby_version, type: :string, default: '2.2.3',
      desc: 'Set Ruby version used'

    protected

    def get_builder_class
      O2webappizer::AppBuilder
    end
  end
end
