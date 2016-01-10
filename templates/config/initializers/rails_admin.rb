RailsAdmin.config do |config|
  ### Popular gems integration
  config.browser_validations = false

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except Naming::Viewable.models + Naming::Form.structure_models + %w[
        UniqueKey
        Setting
        Rich::RichFile
        Form::Row
      ]
    end
    export do
      except Naming::Viewable.models + Naming::Form.structure_models + %w[
        UniqueKey
      ]
    end
    bulk_delete do
      except Naming::Viewable.models + Naming::Form.structure_models + %w[
        UniqueKey
        Setting
      ]
    end
    show do
      except Naming::Viewable.models + Naming::Form.structure_models + %w[
        UniqueKey
      ]
    end
    edit do
      except %w[
        UniqueKey
      ]
    end
    delete do
      except Naming::Form.structure_models + %w[
        UniqueKey
        Setting
      ]
    end
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Rich::RichFile' do
    navigation_label I18n.t('rich.file.navigation')
    label I18n.t('rich.file.one')
    label_plural I18n.t('rich.file.other')

    object_label_method do
      :name
    end

    configure :rich_file, :jcrop

    list do
      field :rich_file
      field :rich_file_file_name
      field :simplified_type
      field :owner_type
    end

    show do
      field :rich_file
      field :owner_type
    end

    edit do
      field :rich_file do
        fit_image true
      end
      field :owner_type, :enum do
        enum do
          ['cms']
        end
      end
    end
  end
end
