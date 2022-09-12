require "minitest/autorun"
require_relative "../../src/controllers/input_controller.rb"
require_relative "../../src/controllers/game_controller.rb"
require_relative "../../src/models/game_board.rb"
require_relative "../../src/models/position.rb"
require_relative "../../src/models/ship.rb"

class PublicTests < MiniTest::Test
  # def setup
  #     @p1_ships = []
  #     @p1_perf_atk = []
  #     @p2_ships = []
  #     @p2_perf_atk = []
  #     for i, size in [1,2,3,4].zip([4,5,3,2])
  #         pos0 = Position.new(i, i)
  #         pos1 = Position.new(i + 4, i + 4)
  #         @p1_ships << Ship.new(pos0, "Right", size)
  #         @p2_ships << Ship.new(pos1, "Right", size)
  #         for j in 0..(size - 1)
  #             @p2_perf_atk << Position.new(i, i + j)
  #             @p1_perf_atk << Position.new(i + 4, i + j + 4)
  #         end
  #     end
  # end
  def test_to_s
    board = GameBoard.new(9, 9)
    ship1 = Ship.new(Position.new(1, 1), "Down", 3)
    ship2 = Ship.new(Position.new(1, 2), "Down", 3)
    ship3 = Ship.new(Position.new(5, 1), "Right", 4)
    board.add_ship(ship1)
    board.add_ship(ship2)
    board.add_ship(ship3)

    board.attack_pos(Position.new(1, 1))
    board.attack_pos(Position.new(1, 3))
    board.attack_pos(Position.new(1, 4))
  end

  def test_add_ship
    board = GameBoard.new(10, 10)
    ship1 = Ship.new(Position.new(1, 1), "Down", 3)
    assert(board.add_ship(ship1))
    assert(!board.add_ship(ship1))
    ship2 = Ship.new(Position.new(1, 2), "Down", 3)
    assert(board.add_ship(ship2))
    ship3 = Ship.new(Position.new(1, 1), "Up", 3)
    assert(!board.add_ship(ship3))
    ship4 = Ship.new(Position.new(9, 9), "Down", 5)
    assert(!board.add_ship(ship4))
  end

  def test_attack_pos_1
    board = GameBoard.new(4, 4)
    ship1 = Ship.new(Position.new(1, 1), "Down", 3)
    assert(board.add_ship ship1)
    assert(!board.all_sunk?)
    assert(board.attack_pos Position.new(1, 1))
    assert(!board.all_sunk?)
    assert(board.attack_pos Position.new(2, 1))
    assert(!board.all_sunk?)
    assert(board.attack_pos Position.new(3, 1))
    assert(board.all_sunk?)
  end

  def test_attack_pos_2
    ship_coords = [[1, 1], [2, 1], [3, 1]]
    board = GameBoard.new(4, 4)
    ship1 = Ship.new(Position.new(1, 1), "Down", 3)
    assert(!board.attack_pos(Position.new(1, 2)))
    assert(!board.attack_pos(Position.new(4, 4)))
  end

  def test_attack_pos_3
    ship_coords = [[1, 1], [2, 1], [3, 1]]
    board = GameBoard.new(4, 4)
    ship1 = Ship.new(Position.new(1, 1), "Down", 3)
    assert(board.add_ship(ship1))
    for row in 1..4
      for col in 1..4
        coord = [row, col]
        if ship_coords.include? coord
          assert(board.attack_pos(Position.new(row, col)))
        else
          assert(!board.attack_pos(Position.new(row, col)))
        end
      end
    end
  end
end
