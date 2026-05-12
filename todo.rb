path = "tasks.txt"

def load_tasks(path)
    File.read(path).split("\n").map do |line|
        cols = line.split("\t")
        { id: cols[0].to_i, title: cols[1], done: cols[2] == "true" }
    end
end

tasks = File.exist?(path) ? load_tasks(path) : []

case ARGV[0]
when "add"
    id = tasks.empty? ? 1 : tasks.map { |task| task[:id] }.max + 1
    tasks << { id: id, title: ARGV[1], done: false}
    File.write(path, tasks.map { |t| "#{t[:id]}\t#{t[:title]}\t#{t[:done]}"}.join("\n"))
    puts "追加しました: #{ARGV[1]}"
when "list"
    tasks.each do |t|
        fin = t[:done] ? "[x]" : "[ ]"
        puts "[#{t[:id]}] #{fin} #{t[:title]}"
    end
end


