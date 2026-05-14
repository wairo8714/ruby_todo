require_relative "task"
require_relative "todo_list"
require_relative "task_repository"

class TodoListInterface
  def list
    todo_list = TaskRepository.get
    lines = []
    todo_list.tasks.each { |task| lines << format(task) }
    lines
  end

  def add(title:)
    todo_list = TaskRepository.get
    task = Task.new(id: todo_list.next_id, title: title)
    todo_list.add(task)
    TaskRepository.save(todo_list)
    task
  end

  def done(id:)
    todo_list = TaskRepository.get
    task = todo_list.done(id)
    TaskRepository.save(todo_list)
    task
  end

  def delete(id:)
    todo_list = TaskRepository.get
    task = todo_list.delete(id)
    TaskRepository.save(todo_list)
    task
  end

  private

  def format(task)
    mark = task.done? ? "[x]" : "[ ]"
    "[#{task.id}] #{mark} #{task.title}"
  end
end
