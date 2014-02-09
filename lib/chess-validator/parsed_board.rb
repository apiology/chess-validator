module ChessValidator
  # A Board which was parsed from a string per the representation at
  # http://www.puzzlenode.com/puzzles/13-chess-validator
  class ParsedBoard < Board
    def initialize(board)
      @checker = PathChecker.new(self)
      @squares = parse_board(board)
    end

    private

    def parse_board(board)
      board.each_line.map do |line|
        parse_rank(line)
      end.reverse # ranks of the last line of the file is 1...
    end

    PIECE_TYPES = {
      'K' => King,
      'B' => Bishop,
      'Q' => Queen,
      'R' => Rook,
      'P' => Pawn,
      'N' => Knight
    }

    PIECE_COLORS = {
      'w' => :white,
      'b' => :black
    }

    def parse_rank(line)
      line.split(' ').map do |piece|
        parse_piece(piece)
      end
    end

    def parse_piece(piece)
      if piece == '--'
        EmptySquare.new
      else
        piece_type = PIECE_TYPES[piece[1]]
        fail "Couldn't understand type of #{piece}" if piece_type.nil?
        piece_color = PIECE_COLORS[piece[0]]
        fail "Couldn't understand color of #{piece}" if piece_color.nil?
        OccupiedSquare.new(piece_color, piece_type.new(@checker))
      end
    end
  end
end
