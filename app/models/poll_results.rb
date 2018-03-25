class PollResults
  include Enumerable

  def initialize(columns, data)
    @columns = columns
    @data = data
  end

  def each(&block)
    @data.each do |data|
      block.call map_to_columns(data)
    end
  end

  def size
    @data.size
  end

  private

  def map_to_columns(data)
    @columns.map do |key, idx|
      [key, data[idx]]
    end.to_h
  end
end
