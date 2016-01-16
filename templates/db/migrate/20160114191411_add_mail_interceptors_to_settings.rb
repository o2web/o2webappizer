class AddMailInterceptorsToSettings < ActiveRecord::Migration
  def up
    Setting.apply_all(
      mail_interceptors: ['rails@admin.cms', 'used in staging only'],
    )
  end
  def down
    Setting.remove_all(
      :mail_interceptors,
    )
  end
end
