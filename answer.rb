require "json"

PATH = "tasks.json"

def load_tasks(path)
  return [] unless File.exist?(path)

  raw = File.read(path).strip
  return [] if raw.empty?

  JSON.parse(raw, symbolize_names: true)
end

def save_tasks(path, tasks)
  File.write(path, JSON.generate(tasks))
end

def next_id(tasks)
  tasks.empty? ? 1 : tasks.map { |t| t[:id] }.max + 1
end

tasks = load_tasks(PATH)

case ARGV[0]
when "add"
  title = ARGV[1]
  tasks << { id: next_id(tasks), title: title, done: false }
  save_tasks(PATH, tasks)
  puts "追加しました: #{title}"
when "list"
  tasks.each do |t|
    mark = t[:done] ? "[x]" : "[ ]"
    puts "[#{t[:id]}] #{mark} #{t[:title]}"
  end
when "delete"
  id = ARGV[1].to_i
  tasks.reject! { |t| t[:id] == id }
  save_tasks(PATH, tasks)
else
  warn "使い方: ruby todo.rb add \"...\" | list | delete ID"
end