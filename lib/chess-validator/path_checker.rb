module ChessValidator
  # Checks whether a given move is valid along a given path
  class PathChecker
    def initialize(board)
      @board = board
    end

    def king_would_be_in_check?(from, to)
      new_board = @board.make_move(from, to)

      new_board.king_is_in_check?(to)
    end

    def backwards?(from, to)
      if square(from).color == :white
        from.rank > to.rank
      else
        to.rank > from.rank
      end
    end

    def valid_capture?(from, to)
      !square(to).clear? &&
        (square(from).color != square(to).color)
    end

    def horizontal_clear?(from, to, capturing_allowed: true)
      horizontal_steps_clear?(from, to) &&
        final_step_allowed?(to, capturing_allowed)
    end

    def vertical_clear?(from, to, capturing_allowed: true)
      vertical_steps_clear?(from, to) &&
        final_step_allowed?(to, capturing_allowed)
    end

    def diagonal_clear?(from, to, capturing_allowed: true)
      diagonal_steps_clear?(from, to) &&
        final_step_allowed?(to, capturing_allowed)
    end

    private

    def square(position)
      @board.square(position)
    end

    def pos(rank, file)
      Position.new(rank, file)
    end

    def horizontal_steps_clear?(from, to)
      horizontal_steps_between(from, to)
        .all? { |square| square.clear? }
    end

    def vertical_steps_clear?(from, to)
      vertical_steps_between(from, to)
        .all? { |square| square.clear? }
    end

    def diagonal_steps_clear?(from, to)
      diagonal_steps_between(from, to)
        .all? { |square| square.clear? }
    end

    def final_step_allowed?(to, capturing_allowed)
      square(to).clear? || capturing_allowed
    end

    def file_steps(from, to)
      if from.file > to.file
        (from.file - 1).downto(to.file + 1)
      else
        (from.file + 1).upto(to.file - 1)
      end
    end

    def rank_steps(from, to)
      if from.rank > to.rank
        (from.rank - 1).downto(to.rank + 1)
      else
        (from.rank + 1).upto(to.rank - 1)
      end
    end

    def horizontal_steps_between(from, to)
      fail unless from.rank == to.rank
      fsteps = file_steps(from, to)
      fsteps.map { |file| square(pos(from.rank, file)) }
    end

    def vertical_steps_between(from, to)
      fail unless from.file == to.file
      rsteps = rank_steps(from, to)
      rsteps.map do |rank|
        square(pos(rank, from.file))
      end
    end

    def diagonal_steps_between(from, to)
      rsteps = rank_steps(from, to)
      fsteps = file_steps(from, to)
      rsteps.zip(fsteps).map do |rank, file|
        square(pos(rank, file))
      end
    end
  end
end
