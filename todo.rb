list = [
    { id: 1, title: "牛乳を買う", done: false },
    { id: 2, title: "rubyを勉強する", done: true },
]

if ARGV[0] == "list"
    list.each do |task|
        fin = task[:done] ? "[x]" : "[ ]"
        puts "[#{task[:id]}] #{fin} #{task[:title]}"
    end
end