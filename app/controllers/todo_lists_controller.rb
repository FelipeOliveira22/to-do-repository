class TodoListsController < ApplicationController
  def index
  @todo_tasks = Task.where(status: "todo")
  @in_progress_tasks = Task.where(status: "in_progress")
  @done_tasks = Task.where(status: "done")
  end
end
