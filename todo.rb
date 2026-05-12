def list_tasks
  puts "牛乳を買う"
  puts "rubyを勉強する"
end

def add_task
  task = ARGV[1]
  puts "追加しました: #{task}"
end

case ARGV[0]
when "list"
  list_tasks
when "add"
  add_task
end