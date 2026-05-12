path = "tasks.txt"

def load_tasks(path)
    File.read(path).split("\n").map do |line|
        cols = line.split("\t")
        { id: cols[0].to_i, title: cols[1], done: cols[2] == "true" }
    end
end

tasks = File.exist?(path) ? load_tasks(path) : []

def save_tasks(path, tasks)
    File.write(path, tasks.map { |t| "#{t[:id]}\t#{t[:title]}\t#{t[:done]}" }.join("\n"))
end

def delete_task(path, id)
    tasks = load_tasks(path)
    tasks.delete_if { |t| t[:id] == id }
    save_tasks(path, tasks)
    puts "削除しました: #{id}"
end

case ARGV[0]
when "delete"
    delete_task(path, ARGV[1].to_i)
when "list"
    load_tasks(path).each do |t|
        fin = t[:done] ? "[x]" : "[ ]"
        puts "[#{t[:id]}] #{fin} #{t[:title]}"
    end
end

    