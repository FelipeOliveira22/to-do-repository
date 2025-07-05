FactoryBot.define do
  factory :task do
    title { "Nova Tarefa" }
    due_date { Date.tomorrow }
    status { "To Do" }
    association :column
  end
end
