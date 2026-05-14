require "json"
require_relative "task"
require_relative "todo_list"

class TaskRepository
  PATH = File.expand_path("../tasks.json", __dir__)

  def self.get
    return TodoList.new unless File.exist?(PATH)

    raw = File.read(PATH).strip
    return TodoList.new if raw.empty?

    loaded_tasks = begin
      JSON.parse(raw).map do |h|
        Task.new(id: h["id"], title: h["title"], done: h["done"])
      end
    rescue JSON::ParserError
      warn "tasks.json の形式が正しくありません。空のリストで続行します。"
      []
    end

    TodoList.new(tasks: loaded_tasks)
  end

  def self.save(todo_list)
    array = []
    todo_list.tasks.each do |task|
      array << { id: task.id, title: task.title, done: task.done? }
    end
    File.write(PATH, JSON.generate(array))
  end
end
