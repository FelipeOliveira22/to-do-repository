Rails.application.routes.draw do
  root "todo_lists#index"

  resources :boards do
    resources :columns do
      resources :tasks do
        patch :move, on: :member
        patch :complete, on: :member
        patch :move_column, on: :member  # ADICIONE ESTA LINHA
      end
    end
  end

  resources :todo_lists
end
