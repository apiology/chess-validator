module ChessValidator
  class PathChecker
    def initialize(board)
      @board = board
    end

    def backwards?(from, to)
      if @board.square(from).color == :white
        from.rank > to.rank
      else
        to.rank > from.rank
      end
    end

    def horizontal_clear?(from, to)
      horiz_path_between(from, to).all? { |square| square.clear? }
    end

    def vertical_clear?(from, to)
      vertical_path_between(from, to).all? { |square| square.clear? }
    end

    def diagonal_clear?(from, to)
      diagonal_path_between(from, to).all? { |square| square.clear? }
    end

    private

    def file_path(from, to)
      if from.file > to.file
        (from.file-1).downto(to.file)
      else
        (from.file+1).upto(to.file)
      end
    end

    def horiz_path_between(from, to)
      fail unless from.rank == to.rank
      fpath = file_path(from, to)
      fpath.map { |file| @board.square(Position.new(from.rank, file)) }
    end

    def rank_path(from, to)
      if from.rank > to.rank
        (from.rank-1).downto(to.rank)
      else
        (from.rank+1).upto(to.rank)
      end
    end

    def vertical_path_between(from, to)
      fail unless from.file == to.file
      rpath = rank_path(from, to)
      rpath.map do |rank|
        @board.square(Position.new(rank, from.file))
      end
    end

    def diagonal_path_between(from, to)
      rpath = rank_path(from, to)
      fpath = file_path(from, to)
      rpath.zip(fpath).map do |rank, file|
        @board.square(Position.new(rank, file))
      end
    end
  end
end
