
require_relative "task"
require_relative "task_repository"
require_relative "error"

class TodoList

  def add(title)
    tasks = TaskRepository.get
    tasks << Task.new(id: next_id(tasks), title: title, done: false)
    TaskRepository.save(tasks)
    puts "追加しました: #{title}"
  end

  def list
    TaskRepository.get.each { |task| puts task.format }
  end

  def done(id)
    tasks = TaskRepository.get
    task = tasks.find { |t| t.id == id }
    raise TaskNotFound, "id=#{id}" unless task
    task.done = true
    TaskRepository.save(tasks)
    puts "完了しました: #{task.title}"
  end

  def delete(id)
    tasks = TaskRepository.get
    task = tasks.find { |t| t.id == id }
    raise TaskNotFound, "id=#{id}" unless task

    tasks.delete(task)
    TaskRepository.save(tasks)
    puts "削除しました: #{task.title}"
  end

  private

  def next_id(tasks)
    tasks.empty? ? 1 : tasks.map(&:id).max + 1
  end
end