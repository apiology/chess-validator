module ChessValidator
  class Square
    attr_reader :piece

    def initialize(piece)
      @piece = piece
    end

    def clear?
      piece.clear?
    end

    def inspect
      "Square(#{piece.to_s})"
    end
  end
end
