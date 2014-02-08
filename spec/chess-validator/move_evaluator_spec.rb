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
    allow(opening_board).to receive(:piece_type).and_return(piece_type)
    expect(evaluator.evaluate(ChessValidator::Position.new(from),
                              ChessValidator::Position.new(to))).to eq ret
  end

  context "In the opening board" do
    subject(:opening_board) { double("opening board") }
    subject(:evaluator) { ChessValidator::MoveEvaluator.new(opening_board) }

    context "the white pawn" do
      it "advances one or two moves, but not three" do
        good(:pawn, 'a2', 'a3')
        good(:pawn, 'a2', 'a4')
        bad(:pawn, 'a2', 'a5')
        good(:pawn, 'e2', 'e3')
      end
    end

    context "the black pawn" do
      it "advances one or two moves, but not three" do
        good(:pawn, 'a7', 'a6')
        good(:pawn, 'a7', 'a5')
        bad(:pawn, 'a7', 'a4')
      end

      it "tries a sneaky diagonal move" do
        bad(:pawn, 'a7', 'b6')
      end
    end

    context "the black rook" do
      it "hooks down and to the left" do
        good(:rook, 'b8', 'a6')
      end
      it "hooks down and to the right" do
        good(:rook, 'b8', 'c6')
      end
      it "hooks too far to the right" do
        bad(:rook, 'b8', 'd7')
      end
    end

    context "invalid piece" do
      it "tries any move" do
        bad(:invalid, 'e3', 'e2')
      end
    end
  end

  context "In a more complex board" do
    subject(:opening_board) { IO.read('spec/samples/complex_board.txt')}
    subject(:evaluator) { ChessValidator::MoveEvaluator.new(opening_board) }
    context "white pawn" do
      it "tries to jump to hyperspace" do
        bad(:pawn, 'f2', 'b7')
      end


    end
    context "piece not on the board" do
      it "tries to do much of anything" do
        bad(:invalid, 'g7', 'g2')
      end
    end
  end
end
