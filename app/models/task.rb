class Task < ApplicationRecord
  belongs_to :todo_list, optional: true
  belongs_to :column

  PRIORITIES = %w[baixa media alta].freeze

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, inclusion: { in: PRIORITIES }, allow_nil: true

  before_validation :set_status_from_column

  private

  def set_status_from_column
    self.status ||= column&.name
  end
end
