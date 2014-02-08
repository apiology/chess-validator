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
      'K' => :king,
      'B' => :bishop,
      'Q' => :queen,
      'R' => :rook,
      'P' => :pawn,
      'N' => :knight
    }

    def parse_rank(line)
      line.split(' ').map do |piece|
        if piece == '--'
          :invalid
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
      if type == :pawn
        vertical_delta(from, to) != 3 &&
          horizontal_delta(from, to) == 0
      elsif type == :knight
        vertical_delta(from, to) == 2
      elsif type == :king
        horizontal_delta(from, to).abs <= 1 &&
          vertical_delta(from, to).abs <= 1
      elsif type == :bishop
        horizontal_delta(from, to) == vertical_delta(from, to)
      elsif type == :rook
        if horizontal_delta(from, to) > 0
          vertical_delta(from, to) == 0
        elsif vertical_delta(from, to) > 0
          true
        else
          true
        end
      elsif type == :invalid
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
