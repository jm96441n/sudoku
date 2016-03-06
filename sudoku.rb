require 'pry'

def solve(board_string, not_simplified=0)
  if board_string.is_a?(String)
    board = make_board(board_string)
  else
    board = board_string
  end

  pretty_board(board)

  if solved?(board) || not_simplified == 500
    pretty_board(board)
  else
    simplify(board, not_simplified)
  end
  # binding.pry
end

def make_board(board_string)
  board_string.scan(/.{9}/).map! do |x|
    x.split('').map do |y|
       y == '-' ? ' ' : y.to_i
    end
  end
end

def simplify(board, not_simplified=0)
  board = unique_possibilities_check(box_check(vertical_check(horizontal_check(board))))
  num_simplified = 0
  #binding.pry
  board.each do |row|
    row.map! do |cell|
      if cell.is_a?(Array) && cell.length == 1
        num_simplified += 1
        cell = cell[0]
      elsif cell.is_a?(Array) && cell.length > 1
        cell = ' '
      else cell = cell
      end
    end
  end

  if num_simplified == 0
    not_simplified += 1
  end
# binding.pry
  solve(board, not_simplified)
end

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
# binding.pry
	board
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
  # binding.pry
  board

end

def box_check(board)
  row_column_coordinates = {
    "top_left" => [[0,1,2],[0,1,2]],
    "top_middle" => [[0,1,2],[3,4,5]],
    "top_right" => [[0,1,2],[6,7,8]],
    "middle_left" => [[3,4,5],[0,1,2]],
    "middle" => [[3,4,5],[3,4,5]],
    "middle_right" => [[3,4,5],[6,7,8]],
    "bottom_left" => [[6,7,8],[0,1,2]],
    "bottom_middle" => [[6,7,8],[3,4,5]],
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
          # binding.pry
          if board[row_num][col_num].is_a?(Array)
            board[row_num][col_num] -= existing_nums_per_box[name]
          end
        end
    end
  end
  #binding.pry
  board
end


def pretty_board(board)
	  board.each {|row| p row}
end


def unique_possibilities_check(board)
  uniques = {
    0 => nil,
    1 => nil,
    2 => nil,
    3 => nil,
    4 => nil,
    5 => nil,
    6 => nil,
    7 => nil,
    8 => nil
  }
  board.each_with_index do |row, index|
    arrays = []
    num_times = Hash.new

    arrays = row.select{|cell| cell.is_a?(Array) && cell.length > 0}.flatten!
    	if arrays != nil
      	arrays.each do |number|
        	if num_times.keys.include?(number)
          	num_times[number] += 1
        	else
          	num_times[number] = 1
        	end
      	end
      uniques[index] = num_times.select {|key,value| value == 1}.keys[0]
     	end
  end

  board.each_with_index do |row, index|
    row.map! do |cell|
      if cell.is_a?(Array) && cell.include?(uniques[index])
        cell = uniques[index]
      else
        cell
      end
    end
  end

  board.transpose.each_with_index do |row, index|
   	arrays = []
    num_times = Hash.new
		arrays = row.select{|cell| cell.is_a?(Array) && cell.length > 0}.flatten!
    if arrays != nil
      arrays.each do |number|
        if num_times.keys.include?(number)
          num_times[number] += 1
        else
          num_times[number] = 1
        end
      end
      uniques[index] = num_times.select {|key,value| value == 1}.keys[0]
    end
  end

  board.transpose.each_with_index do |row, index|
    row.map! do |cell|
      if cell.is_a?(Array) && cell.include?(uniques[index])
        cell = uniques[index]
      else
        cell
      end
    end
  end

	board = box_unique(board)
 #binding.pry
	board

end

def box_unique(board)

  box_unique = {
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

row_column_coordinates = {
    "top_left" => [[0,1,2],[0,1,2]],
    "top_middle" => [[0,1,2],[3,4,5]],
    "top_right" => [[0,1,2],[6,7,8]],
    "middle_left" => [[3,4,5],[0,1,2]],
    "middle" => [[3,4,5],[3,4,5]],
    "middle_right" => [[3,4,5],[6,7,8]],
    "bottom_left" => [[6,7,8],[0,1,2]],
    "bottom_middle" => [[6,7,8],[3,4,5]],
    "bottom_right" => [[6,7,8],[6,7,8]],
  }

 row_column_coordinates.each do |name, coordinates|
  board.slice(coordinates[0].first, 3).each do |row|
      row = row.slice(coordinates[1].first, 3)
      row.select!{|element| element.is_a?(Array)}
      box_unique[name] << row

    end
    box_unique[name].flatten!
    #binding.pry
 end

 box_unique.each do |name, possibilities|
  num_times = Hash.new
  possibilities.each do |number|
    if num_times.keys.include?(number)
      num_times[number] += 1
    else
      num_times[number] = 1
    end
  end
  box_unique[name] = num_times.select{|key,value| value == 1}.keys[0]
   #binding.pry
end

row_column_coordinates.each do |name, coordinates|
    coordinates[0].each do |row_num|
        coordinates[1].each do |col_num|

          if board[row_num][col_num].is_a?(Array) && board[row_num][col_num].include?(box_unique[name])
            board[row_num][col_num] = box_unique[name]
          end
        end
         # binding.pry
    end
  end
  #binding.pry
  board
end






# row[coordinates[1].first..coordinates[1].last]



