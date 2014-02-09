# -*- coding: utf-8 -*-
require 'spec_helper'
require 'chess-validator'

describe ChessValidator::Board do
  subject(:board) { ChessValidator::ParsedBoard.new(board_text) }

  context "In the opening board" do
    subject(:board_text) { IO.read('spec/samples/simple_board.txt') }

    it "can't stand still" do
      all_positions.each do |position|
        bad(position, position)
      end
    end

    context "the white pawn" do
      it "tries to jump to hyperspace" do
        bad('f2', 'b7')
      end

      it "advances one or two moves, but not three" do
        good('a2', 'a3')
        good('a2', 'a4')
        bad('a2', 'a5')
        good('e2', 'e3')
      end
    end

    context "the black pawn" do
      it "advances one or two moves, but not three" do
        good('a7', 'a6')
        good('a7', 'a5')
        bad('a7', 'a4')
      end

      it "tries a sneaky diagonal move" do
        bad('a7', 'b6')
      end
    end

    context "the black knight" do
      it "hooks down and to the left" do
        good('b8', 'a6')
      end
      it "hooks down and to the right" do
        good('b8', 'c6')
      end
      it "tries to capture own piece" do
        bad('b8', 'd7')
      end
    end

    context "invalid piece" do
      it "tries any move" do
        bad('e3', 'e2')
      end
    end
  end

  context "In a more complex board" do
    subject(:board_text) { IO.read('spec/samples/complex_board.txt') }

    context "piece not on the board" do
      it "tries to do much of anything" do
        bad('g7', 'g2')
      end
    end

    # http://en.wikipedia.org/wiki/Rules_of_chess#Basic_moves

    # The king moves exactly one square horizontally, vertically, or
    # diagonally. A special move with the king known as castling is
    # allowed only once per player, per game (see below).
    context "the king" do
      context "moves exactly one square" do
        it "horizontally" do
          good('a8', 'b8')
        end

        it "vertically" do
          good('a8', 'a7')
        end

        it "diagonally" do
          good('a8', 'b7')
        end
      end

      it "can't create check condition from opposite color" do
        bad('e4', 'e5')
      end

      it "can create check condition from same color" do
        good('e4', 'f3')
      end

      it "tries to go somewhere bizarre" do
        bad('a8', 'g5')
      end

      # A special move with the king known as castling is allowed only
      # once per player, per game (see below).
      #
      # Note: not part of puzzlenode.com challenge
      it "tries to castle", wip: true
    end

    # A rook moves any number of vacant squares in a horizontal or
    # vertical direction. It also is moved when castling.
    context "the rook" do
      context "moves any number of vacant squares" do
        it "in a horizontal direction" do
          good('a3', 'b3')
        end

        it "in a vertical direction" do
          good('a3', 'a4')
          good('a3', 'a2')
          good('a3', 'a1')
        end

        it "but not in a diagonal direction" do
          bad('a3', 'b4')
        end

        it "cannot move any other way" do
          bad('c6', 'e8')
        end

        it "cannot skip over occupied squares" do
          bad('c6', 'a6')
        end
      end

      # Note: not part of puzzlenode.com challenge
      it "It also is moved when castling.", wip: true
    end


    # A bishop moves any number of vacant squares in any diagonal direction.
    context "the bishop" do
      it "moves any number of vacant squares" do
        good('f8', 'h6')
        good('f8', 'h6')
        good('f8', 'e7')
        good('f8', 'd6')
      end

      it "does not move in any other direction" do
        bad('f8', 'f7')
        bad('f8', 'c1')
      end

      it "cannot skip over occupied squares" do
        bad('f8', 'b4')
        bad('f1', 'c4')
      end
    end

    # The queen moves any number of vacant squares in a horizontal,
    # vertical, or diagonal direction.
    context "the queen" do
      context "moves any number of vacant squares in a " do
        it "vertical direction" do
          good('f4', 'f3')
          good('f4', 'f5')
          good('f4', 'f6')
        end
        it "horizontal direction" do
          good('f4', 'g4')
        end
        it "diagonal direction" do
          good('f4', 'h2')
        end
        it "does not move in any other direction" do
          bad('f4', 'g2')
        end
        it "cannot skip over occupied squares going vertically" do
          bad('f4', 'f8')
        end
        it "cannot skip over occupied squares going horizontally" do
          bad('f4', 'c4')
        end
        it "cannot skip over occupied squares going diagonally" do
          bad('f4', 'd2')
        end
      end
    end

    # A knight moves to the nearest square not on the same rank, file,
    # or diagonal. (This can be thought of as moving two squares
    # horizontally then one square vertically, or moving one square
    # horizontally then two squares vertically—i.e. in an "L"
    # pattern.) The knight is not blocked by other pieces: it jumps to
    # the new location.
    context "the knight" do
      it "moves to the nearest square not on the same rank, " +
        "file, or diagonal" do
        good('g6', 'e5')
        good('a5', 'b7')
        good('a5', 'c4')
        good('d3', 'e1')
        good('d3', 'c1')
        good('d3', 'b4')
        good('g6', 'h8')
      end

      it "does not move in any other direction" do
        bad('a5', 'a7')
        bad('d3', 'd1')
        bad('g6', 'g1')
        bad('g6', 'h6')
      end

      it "can jump over other pieces" do
        good('d3', 'e5')
      end
    end

    # Pawns have the most complex rules of movement:

    # A pawn moves straight forward one square, if that square is
    # vacant.
    #
    # If it has not yet moved, a pawn also has the option of moving
    # two squares straight forward, provided both squares are
    # vacant.
    #
    # Pawns cannot move backwards.
    #
    # Pawns are the only pieces that capture differently from how they
    # move. A pawn can capture an enemy piece on either of the two
    # squares diagonally in front of the pawn (but cannot move to
    # those squares if they are vacant).
    #
    # The pawn is also involved in the two special moves en passant
    # and promotion (Schiller 2003:17–19).
    context "the pawn" do
      it "moves straight forward one square, if that square is vacant" do
        good('b6', 'b5')
        good('f7', 'f6')
      end

      it "cannot move forward if square is occupied" do
        bad('e3', 'e4')
      end

      it "can move two squares forward if it has not yet moved" do
        good('f7', 'f5')
        good('b2', 'b4')
      end

      it "cannot move two squares forward if one is occupied" do
        bad('f2', 'f4')
        bad('c5', 'c3')
      end

      it "cannot move two squares forward if it has already moved" do
        bad('b6', 'b4')
        bad('h5', 'h7')
      end

      it "cannot move more than two squares" do
        bad('b2', 'b5')
      end

      it "cannot move backwards" do
        bad('b6', 'b7')
        bad('b2', 'b1')
      end

      it "cannot move in any other direction" do
        bad('b6', 'c7')
        bad('b6', 'd4')
        bad('e3', 'e7')
        bad('h5', 'f6')
        bad('h5', 'g5')
      end

      # The pawn is also involved in the two special moves en passant
      # and promotion (Schiller 2003:17–19).
      # Note: not part of puzzlenode.com challenge
      it "has is involved with en passant", wip: true

      # Note: nothing in complex board could get promoted.
      it "has is involved with promotion", wip: true
    end

    context "all pieces" do
      context "can capture opposing pieces" do
        it "as king" do
          good('e4', 'd5')
        end

        it "as rook" do
          good('c6', 'b6')
          good('c6', 'c5')
        end

        it "as bishop" do
          good('c3', 'b2')
          good('e6', 'd5')
        end

        it "as queen" do
          good('c2', 'b2')
          good('c2', 'f2')
          good('c2', 'd3')
        end

        it "as knight" do
          good('d3', 'c5')
        end

        # Pawns are the only pieces that capture differently from how they
        # move.

        # A pawn can capture an enemy piece on either of the two
        # squares diagonally in front of the pawn (but cannot move to
        # those squares if they are vacant).
        context "as pawn" do
          it "can capture an enemy piece on either of the two " +
            " squares diagonally in front of the pawn" do
            good('b6', 'a5')
            good('f7', 'e6')
            good('h5', 'g6')
            good('b2', 'c3')
          end

          it "cannot move to those squares if they are vacant" do
            bad('f2', 'g3')
            bad('c5', 'd4')
          end
        end
      end

      context "cannot capture friendly pieces" do
        it "as king" do
          bad('e4', 'f4')
        end

        it "as rook" do
          bad('c6', 'c3')
          bad('c6', 'e6')
        end

        it "as bishop" do
          bad('f8', 'c5')
          bad('f1', 'd3')
        end

        it "as queen" do
          bad('f4', 'e4')
        end

        it "as knight" do
          bad('d3', 'f2')
        end

        it "as pawn" do
          bad('b6', 'c5')
          bad('f2', 'e3')
        end
      end
    end
  end

  context "In an extra board I wrote" do
    subject(:board_text) { IO.read('spec/samples/extra_board.txt') }

    context "Pawn can't capture by moving" do
      it "directly forwards" do
        bad('b3', 'b4')
      end

      it "directly forward two spaces" do
        bad('h2', 'h4')
      end

      it "directly backwards" do
        bad('g4', 'g3')
      end

      it "diagonally backwards" do
        bad('d4', 'e3')
      end
    end
  end

  def good(from, to)
    try_move(from, to, true)
  end

  def bad(from, to)
    try_move(from, to, false)
  end

  def try_move(from, to, ret)
    expect(board.valid_move?(ChessValidator::Position.parse(from),
                             ChessValidator::Position.parse(to))).to eq ret
  end

  def all_positions
    ('a'..'h').flat_map do |letter|
      (1..8).map { |number| "#{letter}#{number}" }
    end
  end
end
