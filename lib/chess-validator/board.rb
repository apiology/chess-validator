module ChessValidator
  class Board
    def initialize(board)
      @pieces = board.each_line.map do |line|
        parse_rank(line)
      end.reverse # ranks of the last line of the file is 1...
    end

    def evaluate(from, to)
      piece_type(from).valid_move?(from, to)
    end

    private

    def piece_type(position)
      @pieces[position.rank-1][position.file-1]
    end

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
end
