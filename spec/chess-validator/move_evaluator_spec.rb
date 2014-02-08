# -*- coding: utf-8 -*-
require 'spec_helper'
require 'chess-validator'

describe ChessValidator::MoveEvaluator do
  def good(piece_type, from, to)
    try_move(piece_type, from, to, true)
  end

  def bad(piece_type, from, to)
    try_move(piece_type, from, to, false)
  end

  def try_move(piece_type, from, to, ret)
    allow(board).to receive(:piece_type).and_return(piece_type)
    expect(evaluator.evaluate(ChessValidator::Position.new(from),
                              ChessValidator::Position.new(to))).to eq ret
  end

  it "can't stand still", wip: true

  it "tries to capture own piece", wip: true

  context "In the opening board" do
    subject(:board) { double("opening board") }
    subject(:evaluator) { ChessValidator::MoveEvaluator.new(board) }

    context "the white pawn" do
      it "advances one or two moves, but not three" do
        good(ChessValidator::Pawn, 'a2', 'a3')
        good(ChessValidator::Pawn, 'a2', 'a4')
        bad(ChessValidator::Pawn, 'a2', 'a5')
        good(ChessValidator::Pawn, 'e2', 'e3')
      end
    end

    context "the black pawn" do
      it "advances one or two moves, but not three" do
        good(ChessValidator::Pawn, 'a7', 'a6')
        good(ChessValidator::Pawn, 'a7', 'a5')
        bad(ChessValidator::Pawn, 'a7', 'a4')
      end

      it "tries a sneaky diagonal move" do
        bad(ChessValidator::Pawn, 'a7', 'b6')
      end
    end

    context "the black knight" do
      it "hooks down and to the left" do
        good(ChessValidator::Knight, 'b8', 'a6')
      end
      it "hooks down and to the right" do
        good(ChessValidator::Knight, 'b8', 'c6')
      end
      it "hooks too far to the right" do
        bad(ChessValidator::Knight, 'b8', 'd7')
      end
    end

    context "invalid piece" do
      it "tries any move" do
        bad(ChessValidator::Empty, 'e3', 'e2')
      end
    end
  end

  context "In a more complex board" do
    subject(:board) { double('complex board') }
    subject(:evaluator) { ChessValidator::MoveEvaluator.new(board) }
    context "white pawn" do
      it "tries to jump to hyperspace" do
        bad(ChessValidator::Pawn, 'f2', 'b7')
      end
    end

    context "piece not on the board" do
      it "tries to do much of anything" do
        bad(ChessValidator::Empty, 'g7', 'g2')
      end
    end

    # http://en.wikipedia.org/wiki/Rules_of_chess#Basic_moves

    # The king moves exactly one square horizontally, vertically, or
    # diagonally. A special move with the king known as castling is
    # allowed only once per player, per game (see below).
    context "the king" do
      context "moves exactly one square" do
        it "horizontally" do
          good(ChessValidator::King, 'a8', 'b8')
        end

        it "vertically" do
          good(ChessValidator::King, 'a8', 'a7')
        end

        it "diagonally" do
          good(ChessValidator::King, 'a8', 'b7')
        end
      end

      it "tries to go somewhere bizarre" do
        bad(ChessValidator::King, 'a8', 'g5')
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
          good(ChessValidator::Rook, 'a3', 'b3')
        end

        it "in a vertical direction" do
          good(ChessValidator::Rook, 'a3', 'a4')
          good(ChessValidator::Rook, 'a3', 'a2')
          good(ChessValidator::Rook, 'a3', 'a1')
        end

        it "but not in a diagonal direction" do
          bad(ChessValidator::Rook, 'a3', 'b4')
        end
      end

      context "it cannot move any other way", wip: true

      context "it cannot skip over occupied squares", wip: true

      it "It also is moved when castling.", wip: true
    end


    # A bishop moves any number of vacant squares in any diagonal direction.
    context "the bishop" do
      it "moves any number of vacant squares" do
        good(ChessValidator::Bishop, 'f8', 'h6')
        good(ChessValidator::Bishop, 'f8', 'h6')
        good(ChessValidator::Bishop, 'f8', 'e7')
        good(ChessValidator::Bishop, 'f8', 'd6')
      end

      it "does not move in any other direction" do
        bad(ChessValidator::Bishop, 'f8', 'f7')
        bad(ChessValidator::Bishop, 'f8', 'c1')
      end

      context "it cannot skip over occupied squares", wip: true
    end

    # The queen moves any number of vacant squares in a horizontal,
    # vertical, or diagonal direction.
    context "the queen" do
      context "moves any number of vacant squares in a " do
        it "vertical direction" do
          good(ChessValidator::Queen, 'f4', 'f3')
          good(ChessValidator::Queen, 'f4', 'f5')
          good(ChessValidator::Queen, 'f4', 'f6')
        end
        it "horizontal direction" do
          good(ChessValidator::Queen, 'f4', 'g4')
        end
        it "diagonal direction" do
          good(ChessValidator::Queen, 'f4', 'h2')
        end
        it "does not move in any other direction" do
          bad(ChessValidator::Queen, 'f4', 'g2')
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
end
