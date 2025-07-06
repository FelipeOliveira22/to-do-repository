FactoryBot.define do
  factory :user do
    name { "Usuário de Teste" }
    email { "teste@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
  end
end
