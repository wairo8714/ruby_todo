require "json"

PATH = "tasks.json"

class TaskNotFound < StandardError
end

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
    raise TaskNotFound, "id=#{id}" unless task

    task.done = true
    save
  end

  def delete(id)
    raise TaskNotFound, "id=#{id}" unless @tasks.any? { |t| t.id == id }

    @tasks.delete_if { |t| t.id == id }
    save
  end

  private

  def load
    return [] unless File.exist?(@path)

    raw = File.read(@path).strip
    return [] if raw.empty?

    begin
      JSON.parse(raw).map { |h| Task.from_h(h.transform_keys(&:to_sym)) }
    rescue JSON::ParserError
      warn "tasks.json の形式が正しくありません。空のリストで続行します。"
      []
    end
  end

  def save
    File.write(@path, JSON.generate(@tasks.map(&:to_h)))
  end

  def next_id
    @tasks.empty? ? 1 : @tasks.map(&:id).max + 1
  end
end

# 下記case分岐だけでも対応可能だが、先にif分岐を設けることで無駄なファイル読み込みを減らせるらしい 
if ARGV.empty?
  puts "使い方: ruby todo.rb {add|list|done|delete} ..."
  exit 1
end

begin
  todo = TodoList.new(PATH)

  case ARGV[0]
  when "list"   then todo.list
  when "add"    then todo.add(ARGV[1])
  when "done"   then todo.done(ARGV[1].to_i)
  when "delete" then todo.delete(ARGV[1].to_i)
  else
    puts "使い方: ruby todo.rb {add|list|done|delete} ..."
    exit 1
  end
rescue TaskNotFound => e
  warn "タスクが見つかりません: #{e.message}"
  exit 1
end