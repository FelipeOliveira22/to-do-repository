class TodoListsController < ApplicationController
def index
  @todo_column = Column.find_by(name: "To Do")
  @in_progress_column = Column.find_by(name: "In Progress")
  @done_column = Column.find_by(name: "Done")

  @todo_tasks = @todo_column.tasks.order(created_at: :asc)
  @in_progress_tasks = @in_progress_column.tasks.order(created_at: :asc)
  @done_tasks = @done_column.tasks.order(created_at: :asc)
  end
end
