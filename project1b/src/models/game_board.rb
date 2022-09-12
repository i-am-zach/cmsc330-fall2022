require_relative "./position.rb"

class GameBoard
  # @max_row is an `Integer`
  # @max_column is an `Integer`
  attr_reader :max_row, :max_column

  @@BoardShip = Struct.new("BoardShip", :ship, :attacked)

  def initialize(max_row, max_column)
    @max_row = max_row
    @max_column = max_column
    # Hash which maps 2-item tuple keys into BoardShip structs
    @grid = Hash.new(@@BoardShip.new(false, false))
    @ships = []
  end

  def in_range(coord)
    return(
      coord[0] >= 1 && coord[1] >= 1 && coord[0] <= @max_row &&
        coord[1] <= @max_column
    )
  end

  # adds a Ship object to the GameBoard
  # returns Boolean
  # Returns true on successfully added the ship, false otherwise
  # Note that Position pair starts from 1 to max_row/max_column
  def add_ship(ship)
    coords = []
    if self.in_range([ship.start_position.row, ship.start_position.column])
      for i in 0..ship.size - 1
        case ship.orientation
        when "Up"
          coord = [ship.start_position.row - i, ship.start_position.column]
        when "Down"
          coord = [ship.start_position.row + i, ship.start_position.column]
        when "Left"
          coord = [ship.start_position.row, ship.start_position.column - i]
        when "Right"
          coord = [ship.start_position.row, ship.start_position.column + i]
        end
        return false if !self.in_range(coord)
        return false if @grid[coord].ship
        coords.append(coord)
      end
    else
      return false
    end
    for coord in coords
      @grid[coord] = @@BoardShip.new
      @grid[coord].ship = true
      @grid[coord].attacked = false
    end
    @ships.append(ship)
    true
  end

  # return Boolean on whether attack was successful or not (hit a ship?)
  # return nil if Position is invalid (out of the boundary defined)
  def attack_pos(position)
    # check position
    coord = [position.row, position.column]
    return false if !self.in_range(coord)

    # update your grid
    # Need to create new struct because defaults are linked toghether
    @grid[coord] = @@BoardShip.new(@grid[coord].ship, true)

    # return whether the attack was successful or not
    @grid[coord].ship
  end

  # Number of successful attacks made by the "opponent" on this player GameBoard
  def num_successful_attacks
    count = 0
    for coord, board_ship in @grid
      count += 1 if board_ship.ship && board_ship.attacked
    end
    count
  end

  # returns Boolean
  # returns True if all the ships are sunk.
  # Return false if at least one ship hasn't sunk.
  def all_sunk?
    for coord, board_ship in @grid
      return false if board_ship.ship && !board_ship.attacked
    end
    true
  end

  # String representation of GameBoard (optional but recommended)
  def to_s
    ret = "   "
    for row in 1..@max_row
      ret += "   #{row.to_s.rjust(2, "0")}   "
    end
    ret += "\n"
    for row in 1..@max_row
      line = "#{row.to_s.rjust(2, "0")}: "
      for col in 1..@max_column
        ship = @grid[[row, col]].ship
        attacked = @grid[[row, col]].attacked
        line += " "
        line += ship ? "B" : "-"
        line += " , "
        line += attacked ? "A" : "-"
        line += " |"
      end
      ret += line + "\n"
    end
    ret
  end
end
