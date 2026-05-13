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