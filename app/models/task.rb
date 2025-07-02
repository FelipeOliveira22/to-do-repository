class Task < ApplicationRecord
  belongs_to :todo_list

  validates :title, presence: true
  validates :priority, numericality: { only_integer: true }, allow_nil: true
end
