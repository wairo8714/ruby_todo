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
    task = find_by_id(id)
    raise TaskNotFound, "id=#{id}" unless task
    task.done
    task
  end

  def delete(id)
    task = find_by_id(id)
    raise TaskNotFound, "id=#{id}" unless task
    @tasks.delete(task)
    task
  end

  def next_id
    @tasks.empty? ? 1 : @tasks.map(&:id).max + 1
  end

  private

  def find_by_id(id)
    @tasks.find { |t| t.id == id }
  end
end
