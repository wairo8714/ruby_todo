list = ["牛乳を買う", "rubyを勉強する"]

list.each_with_index do |task, i|
    puts "#{i + 1}. #{task}"
end