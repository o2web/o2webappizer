require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module O2webappizer
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    def finish_template
      invoke :o2webappizer_customization
      super
    end

    def o2webappizer_customization
      invoke :setup_git
    end

    def setup_git
      if !options[:skip_git]
        say 'Initializing git'
        build :init_git
      end
    end

    protected

    def get_builder_class
      O2webappizer::AppBuilder
    end
  end
end
