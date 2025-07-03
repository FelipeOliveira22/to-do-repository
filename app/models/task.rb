class Task < ApplicationRecord
  belongs_to :todo_list, optional: true
  belongs_to :column

  validates :title, presence: true
  validates :priority, numericality: { only_integer: true }, allow_nil: true
  validates :status, presence: true

  before_validation :set_status_from_column

  private

  def set_status_from_column
    self.status ||= column&.name
  end
end
