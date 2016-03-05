require_relative '../sudoku'

board_string = File.readlines('sudoku_puzzles.txt').first.chomp

board = solve(board_string)

describe "Sudoku" do
  it "should have 9 rows" do
    expect(board.size == 9).to eq(true)
  end

  it "should have 9 columns" do
    expect(board.transpose.size == 9).to be(true)
  end

  it "should 1-9 in each row" do
    expect(board.map {|row| row.sort}).to eq([[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]])
  end

  it "should 1-9 in each column" do
    expect(board.transpose.map {|row| row.sort}).to eq([[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]])
  end

end
