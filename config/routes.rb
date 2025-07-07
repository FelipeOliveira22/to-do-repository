
puts "Ambiente: #{Rails.env}"

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "boards#index"

  resources :boards do
    member do
      get :kanban
    end

    resources :columns do
      resources :tasks do
        patch :move, on: :member
        patch :complete, on: :member
      end
    end
  end

  patch "/tasks/:id/move_column", to: "tasks#move_column", as: "move_task_column"

  resources :todo_lists
end
