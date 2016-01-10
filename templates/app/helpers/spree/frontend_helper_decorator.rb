module Spree
  module FrontendHelper
    def flash_messages(opts = {})
      # it turns out that Spree helper is loaded later in the process,
      # so BootstrapFlashMessages::Helpers.flash_messages is overridden
      if flash.key? 'order_completed'
        flash.delete('order_completed')
      end
      super
    end
  end
end
