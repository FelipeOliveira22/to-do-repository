# app/models/board.rb
class Board < ApplicationRecord
  belongs_to :user         # ADICIONADO
  has_many :columns, dependent: :destroy
  has_many :tasks, through: :columns

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }

  def total_tasks
    tasks.count
  end

  def pending_tasks
    tasks.where(done: [ false, nil ]).count
  end

  def completed_tasks
    tasks.where(done: true).count
  end
end

# app/models/column.rb
class Column < ApplicationRecord
  belongs_to :board
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :board_id }

  def tasks_count
    tasks.count
  end
end

# app/models/task.rb (atualizado)
class Task < ApplicationRecord
  belongs_to :column
  belongs_to :todo_list, optional: true

  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :priority, inclusion: { in: [ "baixa", "media", "alta" ] }, allow_nil: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_position, on: :create
  before_validation :set_status_from_column

  scope :pending, -> { where(done: [ false, nil ]) }
  scope :completed, -> { where(done: true) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :ordered, -> { order(:position) }

  def overdue?
    due_date.present? && due_date < Time.current && !done
  end

  def priority_level
    case priority&.downcase
    when "alta" then 3
    when "media" then 2
    when "baixa" then 1
    else 0
    end
  end

  private

  def set_position
    return if position.present?

    last_position = column.tasks.maximum(:position) || -1
    self.position = last_position + 1
  end

  def set_status_from_column
    self.status = column.name if column.present?
  end
end
