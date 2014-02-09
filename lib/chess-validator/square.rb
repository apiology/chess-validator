module ChessValidator
  # No pieces in this square
  class EmptySquare
    def color
      :empty
    end

    def valid_move?(_, _)
      false
    end

    def clear?
      true
    end
  end

  # This square has a piece in it
  class OccupiedSquare
    attr_reader :color

    def initialize(color, piece)
      @color = color
      @piece = piece
    end

    def clear?
      false
    end

    def valid_move?(from, to)
      @piece.valid_move?(from, to)
    end

    def inspect
      "Square(#{color} #{piece.to_s})"
    end
  end
end
