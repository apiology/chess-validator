require_relative 'pieces'
require_relative 'square'
require_relative 'path_checker'

module ChessValidator
  class Board
    attr_writer :checker, :squares

    def initialize(squares)
      @squares = squares
      @checker = PathChecker.new(self)
    end

    def valid_move?(from, to)
      !same_color?(from, to) && from != to && square(from).valid_move?(from, to)
    end

    def make_move(from, to)
      new_squares = @squares.dup
      new_squares[to.rank-1][to.file-1] = new_squares[from.rank-1][from.file-1]
      new_squares[from.rank-1][from.file-1] = EmptySquare.new
      Board.new(new_squares)
    end

    def king_is_in_check?(position)
      all_positions.any? do |from|
        !square(from).clear? &&
          square(from).color != square(position).color &&
          valid_move?(from, position)
      end
    end

    def square(position)
      @squares[position.rank-1][position.file-1]
    end

    private

    def same_color?(from, to)
      square(from).color == square(to).color
    end

    def all_positions
      all_ranks.zip(all_files).map { |rank, file| Position.new(rank, file) }
    end

    def all_ranks
      (1..8)
    end

    def all_files
      (1..8)
    end
  end
end
