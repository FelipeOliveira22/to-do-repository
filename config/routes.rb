Rails.application.routes.draw do
  root "boards#index"

  resources :boards do
    member do
      get :kanban    # => /boards/:id/kanban para exibir o quadro Kanban do board
    end

    resources :columns do
      resources :tasks do
        patch :move, on: :member
        patch :complete, on: :member
        # NÃO COLOQUE o move_column aqui
      end
    end
  end

  # ✅ ROTA DIRETA PARA FETCH DO JS (drag and drop)
  patch "/tasks/:id/move_column", to: "tasks#move_column", as: "move_task_column"

  resources :todo_lists
end
