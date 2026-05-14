$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "task"
require "todo_list"
require "error"
require "task_repository"

begin
  list = TodoList.new

  case ARGV[0]
  when "list"   then list.list
  when "add"    then list.add(ARGV[1])
  when "done"   then list.done(ARGV[1].to_i)
  when "delete" then list.delete(ARGV[1].to_i)
  else
    puts "使い方: ruby todo.rb {add|list|done|delete}..."
    exit 1
  end
rescue TaskNotFound => e
  warn "タスクが見つかりません: #{e.message}"
  exit 1
end