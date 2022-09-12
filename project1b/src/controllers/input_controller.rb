require_relative "../models/game_board"
require_relative "../models/ship"
require_relative "../models/position"

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
  board = GameBoard.new 10, 10
  ships = []
  shipsRegex = /^\((\d+),(\d+)\), (\w+), (\d+)$/
  exists =
    read_file_lines(path) do |line|
      if line =~ shipsRegex
        row, col, orientation, size = shipsRegex.match(line).captures
        ships.append(
          Ship.new(Position.new(row.to_i, col.to_i), orientation, size.to_i)
        )
      end
      break if ships.size == 5
    end
  return nil if ships.size < 5
  for ship in ships
    board.add_ship(ship)
  end
  board
end

# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
  positions = []
  positionRegex = /^\((\d+),(\d+)\)$/
  exists =
    read_file_lines(path) do |line|
      if line =~ positionRegex
        row, col = positionRegex.match(line).captures
        positions.append(Position.new(row.to_i, col.to_i))
      end
    end
  return nil if !exists
  positions
end

# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
  return false unless File.exist? path
  File.open(path).each { |line| yield line } if block_given?

  true
end
