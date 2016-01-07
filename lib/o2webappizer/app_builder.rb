module O2webappizer
  class AppBuilder < Rails::AppBuilder
    def readme
      template 'README.md.erb', 'README.md'
    end

    def init_git
      git :init
    end
  end
end
