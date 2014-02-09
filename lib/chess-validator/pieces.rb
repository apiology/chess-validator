# rank == rows == numbers
# file == columns == numbers
module ChessValidator
  # Represents a type of chess piece (Pawn/Rook/Knight/etc)
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
      vdelta = vertical_delta(from, to)
      hdelta = horizontal_delta(from, to)
      if @checker.backwards?(from, to)
        false
      # a forward diagonal move can capture...
      elsif vdelta == 1 && hdelta == 1 && @checker.valid_capture?(from, to)
        true
      # no other sideways movement allowed.
      elsif hdelta != 0
        false
      # moving forward two spaces is allowed from the initial
      # position, so long as it doesn't capture.
      elsif vdelta == 2
        (from.rank == 2 || from.rank == 7) &&
          @checker.vertical_clear?(from, to,
                                   capturing_allowed: false)
      # moving forward one spaces is always allowed, so long as it
      # doesn't capture.
      elsif vdelta == 1
        @checker.vertical_clear?(from, to,
                                 capturing_allowed: false)
      else
        false
      end
    end
  end

  class Knight < PieceType
    def valid_move?(from, to)
      vert = vertical_delta(from, to)
      horiz = horizontal_delta(from, to)
      (vert == 2 && horiz == 1) || (horiz == 2 && vert == 1)
    end
  end

  class King < PieceType
    def valid_move?(from, to)
      horizontal_delta(from, to) <= 1 &&
        vertical_delta(from, to) <= 1 &&
        !@checker.king_would_be_in_check?(from, to)
    end
  end

  class Bishop < PieceType
    def valid_move?(from, to)
      horizontal_delta(from, to) == vertical_delta(from, to) &&
        @checker.diagonal_clear?(from, to)
    end
  end

  class Rook < PieceType
    def valid_move?(from, to)
      if horizontal_delta(from, to) > 0
        vertical_delta(from, to) == 0 && @checker.horizontal_clear?(from, to)
      elsif vertical_delta(from, to) > 0
        @checker.vertical_clear?(from, to)
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
        if vert == 0
          @checker.horizontal_clear?(from, to)
        elsif horiz == vert
          @checker.diagonal_clear?(from, to)
        else
          # can only move diagonally, horizontally, or vertically.
          false
        end
      else # horiz is 0
        @checker.vertical_clear?(from, to)
      end
    end
  end
end
