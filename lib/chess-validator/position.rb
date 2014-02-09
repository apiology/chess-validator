module ChessValidator
  # Holds rank and file of positions, both as 1-indexed numbers.
  class Position
    attr_reader :rank, :file

    def initialize(rank, file)
      @rank = rank
      @file = file
    end

    def self.parse(str)
      @str = str
      rank = @str[1].to_i
      # turn letters into numbers
      file = @str[0].ord - 'a'.ord + 1
      Position.new(rank, file)
    end

    def file_str
      (file + 'a'.ord - 1).chr
    end

    def to_s
      "Position(#{file_str}#{rank})"
    end

    def ==(other)
      rank == other.rank && file == other.file
    end
  end
end
