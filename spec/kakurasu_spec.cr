require "spec"
require "../src/kakurasu"

CASES = [
  {
    [5, 6, 1, 2],
    [3, 7, 1, 2],
    [
      [false, false, true, false],
      [true, true, false, true],
      [true, false, false, false],
      [false, true, false, false],
    ],
  },
  {
    [3, 4, 7, 4],
    [nil, nil, 1, 9],
    [
      [false, false, true, false],
      [false, false, true, false],
      [true, false, false, false],
      [false, true, true, true],
    ],
  },
  {
    [21, 4, 38, 26, 23, 8, 8, 39, 37, 41, 10],
    [21, 11, 28, 16, 5, 5, 53, 36, 36, 16, 22],
    [
      [true, false, false, false, true, false, true, true, false, false, false],
      [true, false, false, false, false, false, false, false, false, true, false],
      [false, false, false, false, false, false, false, true, true, false, true],
      [true, true, true, false, false, false, false, false, false, true, false],
      [true, false, false, true, false, false, false, false, false, false, false],
      [false, false, false, false, true, false, false, false, false, false, false],
      [false, false, true, false, true, false, true, true, true, true, true],
      [false, false, true, false, false, true, false, true, true, true, false],
      [true, false, true, false, true, false, false, true, true, true, false],
      [false, false, true, true, false, false, false, false, true, false, false],
      [false, false, false, true, false, false, false, true, false, true, false],
    ],
  },
]

describe Kakurasu do
  CASES.each { |badcols, badrows, expected|
    # Garbage. Have to go from Array(Int32) to Array(Int32?)
    cols = badcols.map { |c| c ? c : nil }.to_a
    rows = badrows.map { |r| r ? r : nil }.to_a
    it "#{cols}, #{rows}" do
      Kakurasu.new(cols, rows).solve.should eq (expected)
    end
  }
end
