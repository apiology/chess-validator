# -*- coding: utf-8 -*-
require 'spec_helper'
require 'chess-validator'

describe ChessValidator::Board do
  it "tries to capture own piece", wip: true

  subject(:board) { ChessValidator::Board.new(board_text) }

  context "In the opening board" do
    subject(:board_text) { IO.read('spec/samples/simple_board.txt') }

    it "can't stand still" do
      all_positions.each do |position|
        bad(position, position)
      end
    end

    context "the white pawn" do
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
      it "hooks too far to the right" do
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

    context "white pawn" do
      it "tries to jump to hyperspace" do
        bad('f2', 'b7')
      end
    end

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

      it "tries to go somewhere bizarre" do
        bad('a8', 'g5')
      end

      # A special move with the king known as castling is allowed only
      # once per player, per game (see below).
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
      end

      context "it cannot move any other way", wip: true

      context "it cannot skip over occupied squares", wip: true

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

      context "it cannot skip over occupied squares", wip: true
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
      end
    end

    # A knight moves to the nearest square not on the same rank, file,
    # or diagonal. (This can be thought of as moving two squares
    # horizontally then one square vertically, or moving one square
    # horizontally then two squares vertically—i.e. in an "L"
    # pattern.) The knight is not blocked by other pieces: it jumps to
    # the new location.
    context "the knight", wip: true

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
    context "the pawn", wip: true
  end

  def good(from, to)
    try_move(from, to, true)
  end

  def bad(from, to)
    try_move(from, to, false)
  end

  def try_move(from, to, ret)
    expect(board.evaluate(ChessValidator::Position.new(from),
                          ChessValidator::Position.new(to))).to eq ret
  end

  def all_positions
    ('a'..'h').flat_map do |letter|
      (1..8).map { |number| "#{letter}#{number}" }
    end
  end
end
