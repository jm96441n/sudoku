require 'pry'
def solve(board_string)
  if board_string.is_a?(String)
    board = make_board(board_string)
  else
    board = board_string
  end
# Takes a board as a string in the format
# you see in the puzzle file. Returns
# something representing a board after
# your solver has tried to solve it.
  if solved?(board)
    pretty_board(board)
  else
    simplify(board)
  end
end

def make_board(board_string)
  board_string.scan(/.{9}/).map! do |x|
    x.split('').map do |y|
       y == '-' ? ' ' : y.to_i
    end
  end
end

def simplify(board)
  board = unique_possibilities_check(box_check(vertical_check(horizontal_check(board))))
  board.each do |row|
    row.map! do |cell|
      if cell.is_a?(Array) && cell.length == 1
        cell = cell[0]
      elsif cell.is_a?(Array) && cell.length > 1
        cell = ' '
      else cell = cell
      end
    end
  end
  solve(board)
end

# Returns a boolean indicating whether
# or not the provided board is solved.
# The input board will be in whatever
# form `solve` returns.
def solved?(board)
	board.each do |row|
		row.each do |cell|
			if !cell.is_a?(Integer)
				return false
			end
		end
	end
	return true
end

def horizontal_check(board)
	board.each do |row|
		check_arr = [1,2,3,4,5,6,7,8,9]
		row.find_all do |cell|
			if cell.is_a?(Integer)
				check_arr.delete(cell)
			end
		end
		row.map! do |cell|
			if !cell.is_a?(Integer)
				cell = check_arr
			else
				cell = cell
			end
		end
	end
	return board
end

def vertical_check(board)
  transposed_board = board.transpose
  transposed_board.each do |column|
    removal_arr = column.select { |cell| cell.is_a?(Integer) }
    column.map! do |cell|
      if cell.is_a?(Array)
        cell = cell - removal_arr
      else
        cell = cell
      end
    end
  end
  board = transposed_board.transpose
  return board

end

def box_check(board)
  row_column_coordinates = {
    "top_left" => [[0,1,2],[0,1,2]],
    "top_middle" => [[3,4,5],[0,1,2]],
    "top_right" => [[6,7,8],[0,1,2]],
    "middle_left" => [[0,1,2],[3,4,5]],
    "middle" => [[3,4,5],[3,4,5]],
    "middle_right" => [[6,7,8],[3,4,5]],
    "bottom_left" => [[0,1,2],[6,7,8]],
    "bottom_middle" => [[3,4,5],[6,7,8]],
    "bottom_right" => [[6,7,8],[6,7,8]],
  }

  existing_nums_per_box = {
    "top_left" => [],
    "top_middle" => [],
    "top_right" => [],
    "middle_left" => [],
    "middle" => [],
    "middle_right" => [],
    "bottom_left" => [],
    "bottom_middle" => [],
    "bottom_right" => [],
  }

  row_column_coordinates.each do |name, coordinates|
    coordinates[0].each do |row_num|
        coordinates[1].each do |col_num|
          if board[row_num][col_num].is_a?(Integer)
            existing_nums_per_box[name] << board[row_num][col_num]
          end
        end
    end
  end

  row_column_coordinates.each do |name, coordinates|
    coordinates[0].each do |row_num|
        coordinates[1].each do |col_num|
          if board[row_num][col_num].is_a?(Array)
            board[row_num][col_num] - existing_nums_per_box[name]
          end
        end
    end
  end

  board
end

# Takes in a board in some form and
# returns a _String_ that's well formatted
# for output to the screen. No `puts` here!
# The input board will be in whatever
# form `solve` returns.
def pretty_board(board)
	  board.each {|row| p row}
end



def unique_possibilities_check(board)
  board.each do |row|
  binding.pry
    arrays = row.select{|cell| cell.is_a?(Array)}.flatten!
    num_times = Hash.new

    arrays.each do |number|
      if num_times.keys.include?(number)
        num_times[number] += 1
      else
        num_times[number] = 1
      end
    end

    unique_num = num_times.select {|key,value| value == 1}.keys

    row.map! do |element|
      if element.is_a?(Array) && element.include?(unique_num)
        element = unique_num
      end
    end
  end

  board

end




