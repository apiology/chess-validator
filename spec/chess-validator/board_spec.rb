require 'spec_helper'
require 'chess-validator'

describe ChessValidator::Board do
  def expect_position(position_str, expected_piece)
    position = ChessValidator::Position.new(position_str)
    expect(board.piece_type(position)).to eq expected_piece
  end

  context "In the opening board" do
    subject(:opening_board) { IO.read('spec/samples/simple_board.txt') }
    subject(:board) { ChessValidator::Board.new(opening_board) }

    [2, 7].each do |pawn_rank|
      subject(:rank) { pawn_rank }
      ('a'..'h').each do |file|
        context "position #{file}#{pawn_rank}" do
          it "is a pawn" do
            expect_position("#{file}#{rank}", ChessValidator::Pawn)
          end
        end
      end
    end
  end

  context "in the complex board" do
    subject(:complex_board) { IO.read('spec/samples/complex_board.txt') }
    subject(:board) { ChessValidator::Board.new(complex_board) }

    context "empty position" do
      it "is empty" do
        expect_position("a2", ChessValidator::Empty)
      end
    end
  end
end
