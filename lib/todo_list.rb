require_relative "task"
require_relative "error"

class TodoList
  attr_reader :tasks

  def initialize(tasks: [])
    @tasks = tasks
  end

  def add(task)
    @tasks << task
  end

  def done(id)
    task = find(id)
    task.done
    task
  end

  def delete(id)
    task = find(id)
    @tasks.delete(task)
    task
  end

  def edit(id, title)
    task = find(id)
    task.edit(title)
    task
  end

  def find(id)
    task = @tasks.find { |t| t.id == id }
    raise TaskNotFound, "id=#{id}" unless task
    task
  end

  def next_id
    @tasks.empty? ? 1 : @tasks.map(&:id).max + 1
  end
end
