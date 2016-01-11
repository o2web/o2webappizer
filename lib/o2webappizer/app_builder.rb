module O2webappizer
  class AppBuilder < Rails::AppBuilder
    def readme
      template 'README.md'
    end

    def gitignore
      template '.gitignore'
    end

    def app
      empty_directory 'app'

      inside 'app' do
        directory 'assets'
        keep_file 'assets/images'
        directory 'controllers'
        keep_file 'controllers/concerns'
        directory 'helpers'
        directory 'mailers'
        directory 'models'
        keep_file 'models/concerns'
        keep_file 'overrides' if options.solidus?
        empty_directory 'views'

        inside 'views' do
          directory 'cms'
          directory 'layouts'
          directory 'spree' if options.solidus?
        end
      end
    end

    def config
      empty_directory 'config'

      inside 'config' do
        template 'routes.rb'
        template 'application.rb'
        configure_application
        template 'database.yml'
        template 'environment.rb'
        template 'secrets.yml'
        directory 'environments'

        inside 'environments' do
          configure_development
          configure_production
          template 'production.rb', 'staging.rb'
          template 'production.rb', 'vagrant.rb'
          configure_staging
          configure_vagrant
        end
        directory 'initializers'
        unless options.solidus?
          remove_file 'initializers/spree.rb'
          remove_file 'initializers/devise.rb'
        end
        empty_directory 'locales'

        inside 'locales' do
          options.locales.each do |locale|
            copy_file 'routes.en.yml', "routes.#{locale}.yml"
            gsub_file "routes.#{locale}.yml", /^en/, locale
            copy_file 'simple_form.en.yml', "simple_form.#{locale}.yml"
            gsub_file "simple_form.#{locale}.yml", /^en/, locale
          end
        end
      end
    end

    def database_yml
    end

    def public_directory
      directory 'public'
    end

    def vendor
      empty_directory 'vendor/assets'

      inside 'vendor/assets' do
        copy_file 'javascripts/jquery.lazyload.js'
        copy_file 'javascripts/modernizr.js'
        directory 'javascripts/rails_admin'
        copy_file 'stylesheets/nprogress-variables.sass'
        directory 'stylesheets/rails_admin'
        directory 'stylesheets/rich'
        if options.solidus?
          directory 'javascripts/spree'
          directory 'stylesheets/spree'
        end
      end
    end

    def leftovers
      template '.ruby-version'

      after_bundle do
        rake 'railties:install:migrations'
        if options.migrate?
          rake 'db:drop' if options.drop?
          rake 'db:create'
          rake 'db:migrate'
        end
        unless options.skip_git?
          git :init
          git add: '.'
          git commit: "-m 'first commit'"
          git checkout: "-b 'staging'"
          git checkout: "-b 'vagrant'"
          git checkout: "-b 'develop'"
        end
      end
    end

    private

    def configure_application
      overrides = if options.solidus?
        <<-OVERRIDES

          # Load application's view overrides
          Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
            Rails.configuration.cache_classes ? require(c) : load(c)
          end
        OVERRIDES
      end

      application <<-APP.strip_heredoc.indent(4)

        config.to_prepare do
          # Load application's model / class decorators
          Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
            Rails.configuration.cache_classes ? require(c) : load(c)
          end
          #{overrides}
        end

        config.i18n.default_locale = :#{options.locales.first}
        config.i18n.available_locales = #{options.locales.map(&:to_sym)}
      APP
    end

    def configure_development
      environment(<<-DEV.strip_heredoc.indent(2), env: 'development')

        config.action_controller.asset_host = 'http://localhost:3000'
        config.action_mailer.asset_host = 'http://localhost:3000'
      DEV
    end

    def configure_production
      configure_env 'production', 'error'
    end

    def configure_staging
      configure_env 'staging', 'info'
    end

    def configure_vagrant
      configure_env 'vagrant', 'info'
    end

    def configure_env(name, level)
      environment(<<-DEV.strip_heredoc.indent(2), env: name)

        # config.action_controller.asset_host = 'http://todo.todo'
        # config.action_mailer.asset_host = 'http://todo.todo'
      DEV
      gsub_file "#{name}.rb", /# config.action_dispatch.+NGINX/,
        "config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX"
      gsub_file "#{name}.rb", /config.log_level = :debug/,
        "config.log_level = :#{level}"
    end
  end
end
