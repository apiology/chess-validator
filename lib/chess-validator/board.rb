require_relative 'pieces'
require_relative 'square'

module ChessValidator
  class Board
    def initialize(board)
      @squares = board.each_line.map do |line|
        parse_rank(line)
      end.reverse # ranks of the last line of the file is 1...
    end

    def square(position)
      @squares[position.rank-1][position.file-1]
    end

    # TODO change to valid_move?
    def evaluate(from, to)
      from_square = square(from)
      to_square = square(to)

      !same_color?(from_square, to_square) &&
        !same_position?(from, to) &&
        from_square.valid_move?(from, to)
    end

    def same_color?(from_square, to_square)
      from_square.color == to_square.color
    end

    # TODO consider operator==
    def same_position?(from, to)
      from.rank == to.rank && from.file == to.file
    end

    private

    PIECE_TYPES = {
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
          EmptySquare.new
        else
          piece_type = PIECE_TYPES[piece[1]]
          fail "Couldn't understand #{piece}" if piece_type.nil?
          color = piece[0] == 'b' ? :black : :white
          Square.new(color, piece_type.new(self))
        end
      end
    end
  end
end
