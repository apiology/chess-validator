module ChessValidator

  class Board
    def piece_type(from)
      if [2, 7].include? rank(from)
        :pawn
      elsif [8].include? rank(from)
        :rook
      else
        :invalid
      end
    end

    private

    def rank(position)
      position[1].to_i
    end

    def file(position)
      position[0].ord - 'a'.ord + 1
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
      (file(to) - file(from)).abs
    end

    def vertical_delta(from, to)
      (rank(to) - rank(from)).abs
    end

    def rank(position)
      position[1].to_i
    end

    def file(position)
      position[0].ord - 'a'.ord + 1
    end
  end
end
