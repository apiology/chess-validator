module ChessValidator

  class Pawn
  end

  class Knight
  end

  class King
  end

  class Bishop
  end

  class Rook
  end

  class Queen
  end

  class Empty
  end

  class Position
    attr_reader :rank, :file

    def initialize(str)
      @str = str
      @rank = @str[1].to_i
      @file = @str[0].ord - 'a'.ord + 1
    end
  end

  class Board
    def initialize(board)
      @pieces = board.each_line.map do |line|
        parse_rank(line)
      end.reverse # ranks of the last line of the file is 1...
    end

    def piece_type(position)
      @pieces[position.rank-1][position.file-1]
    end

    private

    PIECE_TYPE_STRINGS = {
      'K' => King,
      'B' => Bishop,
      'Q' => Queen,
      'R' => Rook,
      'P' => Pawn,
      'N' => Knight
    }

    def parse_rank(line)
      line.split(' ').map do |piece|
        if piece == '--'
          Empty
        else
          piece_type = PIECE_TYPE_STRINGS[piece[1]]
          fail "Couldn't understand #{piece}" if piece_type.nil?
          piece_type
        end
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
