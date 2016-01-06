require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module O2webappizer
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    def finish_template
      invoke :o2webappizer_customization
      super
    end

    def o2webappizer_customization

    end
  end
end
