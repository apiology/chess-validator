require_relative 'path_checker'

# rank == rows == numbers
# file == columns == numbers
module ChessValidator
  class PieceType
    def initialize(board)
      @board = board
      @checker = PathChecker.new(board)
    end

    def clear?
      false
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

    def valid_move?(from, to)
      if from.rank == to.rank &&
          from.file == to.file
        false
      else
        internal_valid_move?(from, to)
      end
    end
  end

  class Pawn < PieceType
    def internal_valid_move?(from, to)
      vertical_delta(from, to) != 3 && horizontal_delta(from, to) == 0
    end
  end

  class Knight < PieceType
    def internal_valid_move?(from, to)
      vertical_delta(from, to) == 2
    end
  end

  class King < PieceType
    def internal_valid_move?(from, to)
      horizontal_delta(from, to).abs <= 1 &&
        vertical_delta(from, to).abs <= 1
    end
  end

  class Bishop < PieceType
    def internal_valid_move?(from, to)
      horizontal_delta(from, to) == vertical_delta(from, to) &&
        @checker.diagonal_clear(from, to)
    end
  end

  class Rook < PieceType
    def internal_valid_move?(from, to)
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
    def internal_valid_move?(from, to)
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

  class Empty < PieceType
    def internal_valid_move?(from, to)
      false
    end

    def clear?
      true
    end
  end
end
