module ChessValidator

  class Position
    attr_reader :rank, :file

    def initialize(str)
      @str = str
      @rank = @str[1].to_i
      @file = @str[0].ord - 'a'.ord + 1
    end
  end

  class Board
    def piece_type(from)
      if [2, 7].include? from.rank
        :pawn
      elsif [8].include? from.rank
        :rook
      else
        :invalid
      end
    end
  end

  class MoveEvaluator
    def initialize(board)
      @board = board
    end

    # Ranks are numbers are rows, Files are letters are columns
    def evaluate(from, to)
      type = @board.piece_type(from)
      if type == :pawn
        vertical_delta(from, to) != 3 &&
          horizontal_delta(from, to) == 0
      elsif type == :rook
        vertical_delta(from, to) == 2
      elsif type == :invalid
        false
      else
        fail
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
