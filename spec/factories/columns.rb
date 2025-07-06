FactoryBot.define do
  factory :column do
    title { "Coluna Teste" }
    association :board
  end
end
