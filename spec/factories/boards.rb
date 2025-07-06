FactoryBot.define do
  factory :board do
    title { "Board Teste" }
    association :user
  end
end
