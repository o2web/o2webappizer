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
        template  'helpers/application_helper.rb'
        copy_file 'helpers/spree/frontend_helper_decorator.rb' if options.solidus?
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
        directory 'Backup'
        directory 'deploy'
        directory 'sunzi'
        template  'deploy.rb'
        copy_file 'nginx.app.conf.erb'
        copy_file 'nginx.conf.erb'

        template  'routes.rb'
        template  'application.rb'
        configure_application
        template  'database.yml'
        template  'environment.rb'
        template  'secrets.yml'
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
        directory 'initializers_tt', 'initializers'

        inside 'initializers' do
          unless options.solidus?
            remove_file 'spree.rb'
            remove_file 'devise.rb'
          end
        end
        directory 'locales'

        inside 'locales' do
          options.locales.reject{ |l| l == 'en' }.each do |locale|
            duplicate_locale locale
            duplicate_locale locale, 'routes'
            gsub_file "routes.#{locale}.yml", /page: page/, "page: #{locale}/page"
            gsub_file "routes.#{locale}.yml", /contact: contact/, "contact: #{locale}/contact"
            duplicate_locale locale, 'simple_form'
          end
        end
      end
    end

    def database_yml
    end

    def db
    end

    def lib
      directory 'lib'
      empty_directory_with_keep_file 'lib/assets'
    end

    def public_directory
      directory 'public'
    end

    def vendor
      empty_directory 'vendor/assets'

      inside 'vendor/assets' do
        copy_file 'javascripts/jquery.lazyload.js'
        copy_file 'javascripts/modernizr.custom.js'
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
      copy_file 'Capfile'
      copy_file 'schedule.rb'
      template  'Vagrantfile'

      after_bundle do
        db_directory

        if options.migrate?
          rake 'db:drop' if options.drop?
          rake 'db:create'
          rake 'db:migrate'
          if options.solidus? && options.seed?
            rake_options=[]
            rake_options << "AUTO_ACCEPT=1" if options.auto_accept?
            rake_options << "ADMIN_EMAIL=#{options.admin_email}" if options.admin_email.present?
            rake_options << "ADMIN_PASSWORD=#{options.admin_password}" if options.admin_password.present?
            rake "db:seed #{rake_options.join(' ')}"
            rake "db:data:dump"
          end
        end
        unless options.skip_git?
          git :init
          git add: '.'
          git commit: "-m 'first commit'"
          git checkout: "-b 'staging'"
          git checkout: "-b 'vagrant'"
          git checkout: "-b 'develop'"
        end
        if options.solidus? && options.sample?
          rake 'spree_sample:load' unless Dir["#{destination_root}/public/spree/*"].any?
        end
      end
    end

    private

    def db_directory
      template  'db/seeds.rb'
      rake 'railties:install:migrations'
      Dir['db/migrate/*.rb'].sort.last =~ /(\d{14})_/
      next_timestamp = $1.to_i + 1
      copy_file 'db/migrate/001_add_mail_interceptors_to_settings.rb',
        "db/migrate/#{next_timestamp}_add_mail_interceptors_to_settings.rb"
    end

    def duplicate_locale(locale, name = nil)
      src_name = name ? "#{name}.en.yml" : "en.yml"
      dst_name = name ? "#{name}.#{locale}.yml" : "#{locale}.yml"
      copy_file src_name, dst_name
      gsub_file dst_name, /^en/, locale
    end

    def configure_application
      insert_into_file 'application.rb', %{require "sprockets-derailleur"\n}, after: %{require "sprockets/railtie"\n}

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
          Dir.glob(File.join(File.dirname(__FILE__), "../lib/**/*_decorator*.rb")) do |c|
            Rails.configuration.cache_classes ? require(c) : load(c)
          end
          #{overrides}
        end

        config.time_zone = 'Eastern Time (US & Canada)'

        config.i18n.default_locale = :#{options.locales.first}
        config.i18n.available_locales = #{options.locales.map(&:to_sym)}

        # config.active_job.queue_adapter = :que
        config.active_record.schema_format = :sql

        config.action_view.embed_authenticity_token_in_remote_forms = true

        config.assets.paths << Rails.root.join("app", "assets", "fonts")
        config.assets.paths << Rails.root.join("vendor", "assets", "fonts")
        config.assets.precompile += %w( .svg .eot .woff .ttf)
      APP
    end

    def configure_development
      insert_into_file 'development.rb', %{require_relative '../../lib/middleware/turbo_dev'\n\n},
        before: %{Rails.application.configure do}

      environment(<<-DEV.strip_heredoc.indent(2), env: 'development')

        config.middleware.insert 0, Middleware::TurboDev

        config.action_controller.asset_host = '//localhost:3000'
        config.action_mailer.asset_host = '//localhost:3000'
        config.action_mailer.delivery_method = :letter_opener_web
        config.action_mailer.default_url_options = { :host => "localhost:3000" }
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
      environment(<<-CONFIG.strip_heredoc.indent(2), env: name)

        config.action_controller.asset_host = '//todo.todo'
        config.action_mailer.asset_host = '//todo.todo'
        config.action_mailer.delivery_method = :smtp
        config.action_mailer.smtp_settings = {
          address:              'smtp.mailgun.org',
          port:                 587,
          domain:               'todo.mailgun.org',
          user_name:            'todo',
          password:             'todo',
          authentication:       'plain',
        }
        config.action_mailer.default_url_options = { :host => 'todo.todo' }
      CONFIG
      gsub_file "#{name}.rb", /# config.action_dispatch.+NGINX/,
        "config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX"
      gsub_file "#{name}.rb", /config.log_level = :debug/,
        "config.log_level = :#{level}"
    end
  end
end
