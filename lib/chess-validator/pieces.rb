# rank == rows == numbers
# file == columns == numbers

module ChessValidator
  class PieceType
    def initialize(checker)
      @checker = checker
    end

    def to_s
      self.class.to_s
    end

    def horizontal_delta(from, to)
      (to.file - from.file).abs
    end

    def vertical_delta(from, to)
      (to.rank - from.rank).abs
    end
  end

  class Pawn < PieceType
    def valid_move?(from, to)
      vertical_delta(from, to) != 3 && horizontal_delta(from, to) == 0
    end
  end

  class Knight < PieceType
    def valid_move?(from, to)
      v = vertical_delta(from, to)
      h = horizontal_delta(from, to)
      (v == 2 && h == 1) || (h == 2 && v == 1)
    end
  end

  class King < PieceType
    def valid_move?(from, to)
      horizontal_delta(from, to).abs <= 1 &&
        vertical_delta(from, to).abs <= 1
    end
  end

  class Bishop < PieceType
    def valid_move?(from, to)
      horizontal_delta(from, to) == vertical_delta(from, to) &&
        @checker.diagonal_clear(from, to)
    end
  end

  class Rook < PieceType
    def valid_move?(from, to)
      if horizontal_delta(from, to) > 0
        vertical_delta(from, to) == 0 && @checker.horiz_clear(from, to)
      elsif vertical_delta(from, to) > 0
        @checker.vertical_clear(from, to)
      else
        true
      end
    end
  end

  class Queen < PieceType
    def valid_move?(from, to)
      horiz = horizontal_delta(from, to)
      vert = vertical_delta(from, to)
      if horiz > 0
        vert == 0 || horiz == vert # TODO - need to check clear path
      elsif vert > 0
        @checker.vertical_clear(from, to)
      else
        true
      end
    end
  end
end
