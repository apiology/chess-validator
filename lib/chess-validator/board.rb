require_relative 'pieces'
require_relative 'square'
require_relative 'path_checker'

module ChessValidator
  class Board
    def initialize(board)
      @checker = PathChecker.new(self)
      @squares = parse_board(board)
    end

    def valid_move?(from, to)
      !same_color?(from, to) &&
        from != to &&
        square(from).valid_move?(from, to)
    end

    def square(position)
      @squares[position.rank-1][position.file-1]
    end

    private

    def same_color?(from, to)
      square(from).color == square(to).color
    end

    PIECE_TYPES = {
      'K' => King,
      'B' => Bishop,
      'Q' => Queen,
      'R' => Rook,
      'P' => Pawn,
      'N' => Knight
    }

    PIECE_COLOR = {
      'w' => :white,
      'b' => :black
    }

    def parse_board(board)
      board.each_line.map do |line|
        parse_rank(line)
      end.reverse # ranks of the last line of the file is 1...
    end

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
        piece_color = PIECE_COLOR[piece[0]]
        fail "Couldn't understand color of #{piece}" if piece_color.nil?
        Square.new(piece_color, piece_type.new(@checker))
      end
    end
  end
end
