require 'spec_helper'

# http://www.puzzlenode.com/puzzles/13-chess-validator

# A company that specializes in building mediocre games for social
# networking platforms has offered you a fistful of cash in the form
# of a one percent profit sharing agreement and free pizza. All you
# need to do is prove that you're the kind of rockstar programmer they
# need on staff by taking a simple test. Because you know that you're
# exactly the sort of ninja frogman devops superstar that they're
# looking for, you decide to give it a shot.

# Your task is to create a Chess move validator: given a list of moves
# and a board, you are expected to determine whether each move is
# LEGAL or ILLEGAL. Some sample input and output files are provided to
# make this task a little bit easier for you to work on.

describe "Chess validator" do
  it "starts up with no arguments" do
    expect(exec_io "chess")
      .to eq("USAGE: chess [input board file] < [moves file]\n")
  end

  # The Board

  # The board is represented in the simple ASCII format shown below:

  # bR bN bB bQ bK bB bN bR
  # bP bP bP bP bP bP bP bP
  # -- -- -- -- -- -- -- --
  # -- -- -- -- -- -- -- --
  # -- -- -- -- -- -- -- --
  # -- -- -- -- -- -- -- --
  # wP wP wP wP wP wP wP wP
  # wR wN wB wQ wK wB wN wR

  # Each piece is represented by two characters. The first character
  # represents the player's color, and the second character represents
  # the rank of the piece. Empty squares are represented by --.

  # Evaluating Moves

  # Moves are listed using coordinates similar to algebraic chess
  # notation, but start and ending positions are provided explicitly for
  # each move to avoid the need to resolve ambiguities. One move is
  # listed per line in the moves file, as shown below:

  #  a2 a3
  #  a2 a4
  #  a2 a5
  #  a7 a6
  #  a7 a5
  #  a7 a4
  #  a7 b6
  #  b8 a6
  #  b8 c6
  #  b8 d7
  #  e2 e3
  #  e3 e2

  # Each move should be evaluated independently against the provided
  # board layout. The purpose of your validator will be to determine
  # whether a given move is legal based on the initial board state: it
  # is not meant to evaluate a sequence of moves.

  # While the simple_moves.txt file only checks some basic pawn and
  # knight moves, the complex_moves.txt exercises most of the kinds of
  # moves you would find in an ordinary chess game, as well as various
  # forms of invalid moves. While you are expected to test for whether a
  # move would be illegal due to creating a check condition, you can
  # assume that no moves involve castling or en-passant conditions.

  # Expected Output

  # For each move in your input file, there should be a corresponding
  # line in your output file which indicates whether the move was LEGAL
  # or ILLEGAL. For example, given the previously shown board
  # (simple_board.txt) and move list (simple_moves.txt), your validator
  # should output the following results:

  #  LEGAL
  #  LEGAL
  #  ILLEGAL
  #  LEGAL
  #  LEGAL
  #  ILLEGAL
  #  ILLEGAL
  #  LEGAL
  #  LEGAL
  #  ILLEGAL
  #  LEGAL
  #  ILLEGAL

  #  Submitting Your Results

  # You are expected to run your validator against the complex_moves.txt
  # and complex_board.txt files and then upload a text file with your
  # results. Keep in mind that the complex_moves.txt file contains many
  # kinds of moves that are not present in the simple_moves.txt file,
  # but that LEGAL moves are those which are valid according to ordinary
  # chess rules.

  # Files

  # 13-chess-validator.md
  # complex_board.txt
  # complex_moves.txt
  # simple_board.txt
  # simple_moves.txt
  # simple_results.txt

  # TODO: Add 'complex' after simple stuff works
  ['simple'].each do |type|
    it "handles #{type} case", wip: true do
      expect(exec_io "cat spec/samples/#{type}_moves.txt | " +
             "chess spec/features/#{type}_board.txt")
      .to eq(IO.read("spec/samples/#{type}_results.txt"))
    end
  end
end
