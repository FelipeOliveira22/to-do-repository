# db/migrate/20250706194500_add_google_event_id_to_tasks.rb
class AddGoogleEventIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :google_event_id, :string
  end
end
