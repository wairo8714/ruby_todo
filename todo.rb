require "json"

PATH = "tasks.json"

class Task
  attr_accessor :id, :title, :done

  def initialize(id:, title:, done: false)
    @id = id
    @title = title
    @done = done
  end

  def to_h
    { id: @id, title: @title, done: @done }
  end

  def self.from_h(hash)
    new(id: hash[:id], title: hash[:title], done: hash[:done])
  end

  def format
    mark = @done ? "[x]" : "[ ]"
    "[#{@id}] #{mark} #{@title}"
  end
end

def load_tasks(path)
  return [] unless File.exist?(path)

  raw = File.read(path).strip
  return [] if raw.empty?

  JSON.parse(raw).map { |h| Task.from_h(h.transform_keys(&:to_sym)) }
end

def save_tasks(path, tasks)
  File.write(path, JSON.generate(tasks.map(&:to_h)))
end

def next_id(tasks)
  tasks.empty? ? 1 : tasks.map(&:id).max + 1
end

tasks = load_tasks(PATH)

case ARGV[0]
when "add"
  title = ARGV[1]
  tasks << Task.new(id: next_id(tasks), title: title, done: false)
  save_tasks(PATH, tasks)
  puts "追加しました: #{title}"
when "list"
  tasks.each { |t| puts t.format}
when "delete"
  id = ARGV[1].to_i
  tasks.delete_if { |t| t.id == id}
  save_tasks(PATH, tasks)
end