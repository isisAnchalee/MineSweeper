# encoding: UTF-8
class Tile
  DIFFS = [
    [1,  0],
    [-1,  0],
    [1,  1],
    [0, -1],
    [0,  1],
    [1, -1],
    [-1, -1],
    [-1,  1]
  ]
  
  NUM_SQUARES = {
    1 => "1⃣",
    2 => "2⃣",
    3 => "3⃣",
    4 => "4⃣",
    5 => "5⃣",
    6 => "6⃣",
    7 => "7⃣",
    8 => "8⃣"
  }

  attr_accessor :bomb, :revealed, :board, :bomb_count
  attr_reader :flag, :pos
  
  def initialize(board, pos, bomb = false, flag = false, revealed = false)
    @board = board
    @pos = pos
    @flag = flag
    @bomb = bomb
    @revealed = revealed
    @bomb_count = nil
  end

  def neighbor_bomb_count
    b_count = 0

    neighbors.each do |tile|
      b_count += 1 if tile.bomb
    end

    b_count
  end

  def flag_tile
    @flag = true
  end

  def reveal_tile
    self.revealed = true
    if neighbor_bomb_count == 0
      neighbors.each { |tile| tile.reveal_tile unless tile.revealed }
    else
      self.bomb_count = neighbor_bomb_count
    end
  end

  def neighbors
    array = []

    DIFFS.each do |coord|
      x, y = @pos.first + coord.first, @pos.last + coord.last
      array << board.grid[x][y] if x.between?(0, 8) && y.between?(0, 8)
    end

    array
  end

  def display
    return "🚩" if flag
    return "💣" if bomb && revealed
    return "#{NUM_SQUARES[bomb_count]}" if revealed && bomb_count
    return  '_' if revealed
    "🔲"
  end
  
end
