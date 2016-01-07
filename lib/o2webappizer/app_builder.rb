module O2webappizer
  class AppBuilder < Rails::AppBuilder
    def readme
      template 'README.md.erb', 'README.md', force: true
    end

    def init_git
      git :init
    end
  end
end
