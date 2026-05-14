require_relative "lib/error"
require_relative "lib/task"
require_relative "lib/todo_list"
require_relative "lib/task_repository"
require_relative "lib/todo_list_interface"

interface = TodoListInterface.new

begin
  case ARGV[0]
  when "list"
    interface.list.each { |line| puts line }
  when "add"
    title = ARGV[1]
    task = interface.add(title: title)
    puts "追加しました: #{task.title}"
  when "done"
    id = ARGV[1].to_i
    task = interface.done(id: id)
    puts "完了しました: #{task.title}"
  when "delete"
    id = ARGV[1].to_i
    task = interface.delete(id: id)
    puts "削除しました: #{task.title}"
  when "edit"
    id = ARGV[1].to_i
    task = interface.find(id: id)

    puts "現在のタイトル: #{task.title}"
    puts "新しいタイトルを入力してください"

    new_title = STDIN.gets.chomp.strip
    edited_task = interface.edit(id: id, title: new_title)

    puts "タイトルを変更しました: #{edited_task.title}"
  else
    puts "使い方: ruby todo.rb {add|list|done|delete|edit} ..."
    exit 1
  end
rescue TaskNotFound => e
  warn "タスクが見つかりません: #{e.message}"
  exit 1
rescue EmptyTitleError => e
  warn "タイトルを入力してください: #{e.message}"
  exit 1
end
