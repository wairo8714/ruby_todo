require "json"

PATH = "tasks.json"

class Task  #クラスに記述するのは、「ひとつのタスクが行う挙動」である

  # attr_accesorをつかえばインスタンス変数がタスクの外から参照、書き込みできるようになる
  attr_accessor :id, :title, :done

  # initializeメソッドを使うことで、まだオブジェクトが作られていない段階でインスタンスの初期化ができる
  def initialize(id:, title:, done: false)
    @id = id
    @title = title
    @done = done
  end

  def to_h
    { id: @id, title: @title, done: @done }
  end

  def self.from_h(h)
    new(id: h[:id], title: h[:title], done: h[:done])
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
  tasks.each { |t| puts t.format }
when "delete"
  id = ARGV[1].to_i
  tasks.reject! { |t| t.i d == id }
  save_tasks(PATH, tasks)
end