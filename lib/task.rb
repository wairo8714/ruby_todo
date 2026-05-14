class EmptyTitleError < StandardError
end

class Task
  attr_reader :id, :title

  def initialize(id:, title:, done: false)
    raise EmptyTitleError if title.nil? || title.strip.empty?

    @id = id
    @title = title
    @done = done
  end

  def done
    @done = true
  end

  def done?
    @done
  end

  def edit(title)
    raise EmptyTitleError if title.nil? || title.strip.empty?
    @title = title
  end
end