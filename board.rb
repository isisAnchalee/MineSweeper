class Board
  attr_accessor :grid, :game_over
  attr_reader :bomb_count, :size

  def initialize(size = 9, bomb_count = 10)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    place_tiles
    set_bombs(bomb_count)
  end

  def place_tiles
    (0...@grid.length).each do |x|
      (0...@grid.length).each do |y|
        @grid[x][y] = Tile.new(self, [x, y])
      end
    end
  end

  def set_bombs(bomb_count)
    bomb_coords = []

    until bomb_coords.length == bomb_count
      x, y = (0..8).to_a.sample, (0..8).to_a.sample
      bomb_coords << [x, y] unless bomb_coords.include?([x, y])
    end

    bomb_coords.each { |coord| @grid[coord[0]][coord[-1]].bomb = true }
  end
  
  def tiles
    @grid.flatten
  end
  
  def validate_coordinate(coord)
    coord.first.between?(0, size) && coord.last.between?(0, size)
  end
  
  def display_complete_board
    tiles.each { |tile| tile.revealed = true }
    display_board
  end


  def display_board
    puts "     MINESWEEPER"
    puts '  0 1 2 3 4 5 6 7 8'
    (0...@grid.length).each do |x|
      print "#{x} "
      (0...@grid.length).each do |y|
        print @grid[x][y].display +  ' '
      end
      puts
    end
  end
end
