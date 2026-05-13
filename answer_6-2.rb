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

class TodoList
  def initialize(path)
    @path = path
    @tasks = load
  end

  def add(title)
    @tasks << Task.new(id: next_id, title: title, done: false)
    save
    puts "追加しました: #{title}"
  end

  def list
    @tasks.each { |t| puts t.format }
  end

  def done(id)
    task = @tasks.find { |t| t.id == id }
    if task
      task.done = true
      save
    else
      puts "IDがみつかりません"
    end
  end

  def delete(id)
    @tasks.delete_if { |t| t.id == id }
    save
  end

  private

  def load
    return [] unless File.exist?(@path)

    raw = File.read(@path).strip
    return [] if raw.empty?

    JSON.parse(raw).map { |h| Task.from_h(h.transform_keys(&:to_sym)) }
  end

  def save
    File.write(@path, JSON.generate(@tasks.map(&:to_h)))
  end

  def next_id
    @tasks.empty? ? 1 : @tasks.map(&:id).max + 1
  end
end

list = TodoList.new(PATH)

case ARGV[0]
when "list"   then list.list
when "add"    then list.add(ARGV[1])
when "done"   then list.done(ARGV[1].to_i)
when "delete" then list.delete(ARGV[1].to_i)
else
  warn "使い方: ruby todo.rb list | add \"...\" | done ID | delete ID"
end