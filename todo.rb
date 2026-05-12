command = ARGV[0]
task = ARGV[1]

case
when command == "add"
    puts "追加しました: #{task}"
when command == "list"
    puts "牛乳を買う"
    puts "rubyを勉強する"
end