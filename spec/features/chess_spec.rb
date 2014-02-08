require 'spec_helper'

# http://www.puzzlenode.com/puzzles/13-chess-validator

describe "Chess validator" do
  it "starts up with no arguments" do
    expect(exec_io "chess")
      .to eq("USAGE: chess [input board file] < [moves file]\n")
  end

  # TODO: Add 'complex_1' and 'complex_2' after simple stuff works
  ['simple'].each do |type|
    it "handles #{type} case", wip: false do
      expect(exec_io "cat spec/samples/#{type}_moves.txt | " +
             "chess spec/samples/#{type}_board.txt")
      .to eq(IO.read("spec/samples/#{type}_results.txt"))
    end
  end
end
