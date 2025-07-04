Rails.application.routes.draw do
  root "todo_lists#index"

  resources :boards do
    resources :columns do
      resources :tasks do
        patch :move, on: :member
        patch :complete, on: :member
        # NÃO COLOQUE o move_column aqui
      end
    end
  end

  # ✅ ROTA DIRETA PARA O FETCH DO JS
  patch "/tasks/:id/move_column", to: "tasks#move_column", as: "move_task_column"

  resources :todo_lists
end
