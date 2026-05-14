require "json"
require_relative "task"

class TaskRepository
  PATH = File.expand_path("../tasks.json", __dir__)

  def self.get
    return [] unless File.exist?(PATH)

    raw = File.read(PATH).strip
    return [] if raw.empty?

    begin
      JSON.parse(raw).map { |h| Task.from_h(h.transform_keys(&:to_sym)) }
    rescue JSON::ParserError
      warn "tasks.json の形式が正しくありません。空のリストで続行します。"
      []
    end
  end

  def self.save(tasks)
    File.write(PATH, JSON.generate(tasks.map(&:to_h)))
  end
end