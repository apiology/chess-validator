require 'spec_helper'
require 'chess-validator'

describe ChessValidator::MoveEvaluator do
  subject(:evaluator) { ChessValidator::MoveEvaluator.new }

  context "opening board" do
    { black: 'a', white: 'b'}.each do |color, file|
      context "#{color} pawn" do
        it "advances 1x" do
          expect(evaluator.evaluate('a2', 'a3')).to eq true
        end

        it "advances 2x" do
          expect(evaluator.evaluate('a2', 'a4')).to eq true
        end

        it "advances 3x" do
          expect(evaluator.evaluate('a2', 'a5')).to eq false
        end

        it "advances 3x" do
          expect(evaluator.evaluate('a2', 'a5')).to eq false
        end
      end
    end
  end
end
