class Task < ApplicationRecord
  validates :priority, inclusion: { in: ["low", "medium", "high"] }, allow_blank: true
  belongs_to :todo_list, optional: true
  belongs_to :column

  PRIORITIES = %w[baixa média alta].freeze

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, inclusion: { in: PRIORITIES }, allow_blank: true

  before_validation :set_status_from_column

  # Scopes úteis
  scope :completed, -> { where(done: true) }
  scope :pending, -> { where(done: false) }
  scope :overdue, -> { where("due_date < ? AND done = ?", Time.current, false) }

  # Método para verificar se está atrasada
  def overdue?
    due_date.present? && due_date < Time.current && !done
  end

  private

  def set_status_from_column
    self.status ||= column&.name
  end
end
