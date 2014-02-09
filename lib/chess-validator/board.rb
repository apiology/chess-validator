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

    def evaluate(from, to)
      square(from).piece.valid_move?(from, to)
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
          Square.new(Empty.new(self))
        else
          piece_type = PIECE_TYPES[piece[1]]
          fail "Couldn't understand #{piece}" if piece_type.nil?
          Square.new(piece_type.new(self))
        end
      end
    end
  end
end
