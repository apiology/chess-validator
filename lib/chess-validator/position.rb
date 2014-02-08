module ChessValidator
  class Position
    attr_reader :rank, :file

    def initialize(str)
      @str = str
      @rank = @str[1].to_i
      @file = @str[0].ord - 'a'.ord + 1
    end
  end
end
