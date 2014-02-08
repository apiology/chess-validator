module ChessValidator

  class Piece
    def self.horizontal_delta(from, to)
      (to.file - from.file).abs
    end

    def self.vertical_delta(from, to)
      (to.rank - from.rank).abs
    end

    def self.valid_move?(from, to)
      if from.rank == to.rank &&
          from.file == to.file
        false
      else
        internal_valid_move?(from, to)
      end
    end
  end

  class Pawn < Piece
    def self.internal_valid_move?(from, to)
      vertical_delta(from, to) != 3 && horizontal_delta(from, to) == 0
    end
  end

  class Knight < Piece
    def self.internal_valid_move?(from, to)
      vertical_delta(from, to) == 2
    end
  end

  class King < Piece
    def self.internal_valid_move?(from, to)
      horizontal_delta(from, to).abs <= 1 &&
        vertical_delta(from, to).abs <= 1
    end
  end

  class Bishop < Piece
    def self.internal_valid_move?(from, to)
      horizontal_delta(from, to) == vertical_delta(from, to)
    end
  end

  class Rook < Piece
    def self.internal_valid_move?(from, to)
      if horizontal_delta(from, to) > 0
        vertical_delta(from, to) == 0
      elsif vertical_delta(from, to) > 0
        true
      else
        true
      end
    end
  end

  class Queen < Piece
    def self.internal_valid_move?(from, to)
      horiz = horizontal_delta(from, to)
      vert = vertical_delta(from, to)
      if horiz > 0
        vert == 0 || horiz == vert
      elsif vert > 0
        true
      else
        true
      end
    end
  end

  class Empty < Piece
    def self.internal_valid_move?(from, to)
      false
    end
  end
end
