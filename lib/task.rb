class Task
  attr_reader :id, :title

  def initialize(id:, title:, done: false)
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
end
