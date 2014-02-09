require_relative 'pieces'
require_relative 'square'
require_relative 'path_checker'

module ChessValidator
  # Represents the entire chess board, as an indexed array by (rank,
  # file) of Square objects.
  class Board
    attr_writer :checker, :squares

    def initialize(squares)
      @squares = squares
      @checker = PathChecker.new(self)
    end

    def valid_move?(from, to)
      !same_color?(from, to) && from != to &&
        square(from).valid_move?(from, to)
    end

    def make_move(from, to)
      new_squares = @squares.dup

      new_squares[to.rank - 1][to.file - 1] =
        new_squares[from.rank - 1][from.file - 1]

      new_squares[from.rank - 1][from.file - 1] = EmptySquare.new

      Board.new(new_squares)
    end

    def king_is_in_check?(king_position)
      all_positions.any? do |from|
        !square(from).clear? &&
          square(from).color != square(king_position).color &&
          valid_move?(from, king_position)
      end
    end

    def square(position)
      @squares[position.rank - 1][position.file - 1]
    end

    private

    def same_color?(from, to)
      square(from).color == square(to).color
    end

    def all_positions
      all_ranks_and_files.map { |rank, file| Position.new(rank, file) }
    end

    def all_ranks_and_files
      (1..8).zip(1..8)
    end
  end
end
