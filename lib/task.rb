class Task
  attr_accessor :id, :title, :done

  def initialize(id:, title:, done: false)
    @id = id
    @title = title
    @done = done
  end

  def to_h
    { id: @id, title: @title, done: @done }
  end

  def self.from_h(hash)
    new(id: hash[:id], title: hash[:title], done: hash[:done])
  end

  def format
    mark = @done ? "[x]" : "[ ]"
    "[#{@id}] #{mark} #{@title}"
  end
end