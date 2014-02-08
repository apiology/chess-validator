module ChessValidator
  class MoveEvaluator
    def initialize(board)
      @board = board
    end

    # Ranks are numbers are rows, Files are letters are columns
    def evaluate(from, to)
      type = @board.piece_type(from)
      if type == Pawn
        vertical_delta(from, to) != 3 &&horizontal_delta(from, to) == 0
      elsif type == Knight
        vertical_delta(from, to) == 2
      elsif type == King
        horizontal_delta(from, to).abs <= 1 &&
          vertical_delta(from, to).abs <= 1
      elsif type == Bishop
        horizontal_delta(from, to) == vertical_delta(from, to)
      elsif type == Rook
        if horizontal_delta(from, to) > 0
          vertical_delta(from, to) == 0
        elsif vertical_delta(from, to) > 0
          true
        else
          true
        end
      elsif type == Queen
        horiz = horizontal_delta(from, to)
        vert = vertical_delta(from, to)
        if horiz > 0
          vert == 0 || horiz == vert
        elsif vert > 0
          true
        else
          true
        end
      elsif type == Empty
        false
      else
        fail "Could not understand piece type #{type}"
      end
    end

    private

    def horizontal_delta(from, to)
      (to.file - from.file).abs
    end

    def vertical_delta(from, to)
      (to.rank - from.rank).abs
    end
  end
end
