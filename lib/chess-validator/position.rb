module ChessValidator
  class Position
    attr_reader :rank, :file

    def initialize(rank, file)
      @rank = rank
      @file = file
    end

    def self.parse(str)
      @str = str
      rank = @str[1].to_i
      file = @str[0].ord - 'a'.ord + 1
      Position.new(rank, file)
    end

    def file_str
      (file + 'a'.ord - 1).chr
    end

    def to_s
      "Position(#{file_str}#{rank})"
    end
  end
end
