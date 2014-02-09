# rank == rows == numbers
# file == columns == numbers
module ChessValidator
  class PieceType
    def initialize(board)
      @board = board
    end

    def clear?
      false
    end

    def to_s
      self.class.to_s
    end

    def horiz_path_clear(from, to)
      ret = horiz_path_between(from, to).all? { |square| square.clear? }
      ret
    end

    def vertical_path_clear(from, to)
      ret = vertical_path_between(from, to).all? { |square| square.clear? }
      ret
    end

    def horiz_path_between(from, to)
      fail unless from.rank == to.rank
      if from.file > to.file
        path = (from.file+1).downto(to.file) # TODO this is wrong
      else
        path = (from.file+1).upto(to.file)
      end
      path.map { |file| @board.square(Position.new(from.rank, file)) }
    end

    def vertical_path_between(from, to)
      fail unless from.file == to.file
      if from.rank > to.rank
        path = (from.rank-1).downto(to.rank)
      else
        path = (from.rank+1).upto(to.rank)
      end
      path.map do |rank|
        @board.square(Position.new(rank, from.file))
      end
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
      horizontal_delta(from, to) == vertical_delta(from, to)
    end
  end

  class Rook < PieceType
    def internal_valid_move?(from, to)
      if horizontal_delta(from, to) > 0
        vertical_delta(from, to) == 0 && horiz_path_clear(from, to)
      elsif vertical_delta(from, to) > 0
        vertical_path_clear(from, to)
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
        vertical_path_clear(from, to)
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
