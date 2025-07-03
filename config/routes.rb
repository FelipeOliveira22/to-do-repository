Rails.application.routes.draw do
  root "todo_lists#index"

  resources :boards do
    resources :columns do
      resources :tasks do
        patch :move, on: :member
      end
    end
  end

  resources :todo_lists
end
