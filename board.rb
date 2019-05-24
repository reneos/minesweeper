require_relative './tile.rb'

class Board

  attr_reader :grid, :bombs, :size, :game_over

  def initialize
    @size = 9
    @grid = Array.new(@size) {Array.new(@size)}
    @bombs = []
    @game_over = false
    fill_in_bombs
    fill_in_tiles
    print_grid
  end

  def fill_in_bombs
    num_bombs = @grid.flatten.length / 8
    until num_bombs == 0
      row, col = rand(0...9), rand(0...9)
      if !@bombs.include?([row,col])
        @bombs << [row,col]
        num_bombs -= 1
      end
    end
  end

  def fill_in_tiles
    @grid.length.times do |row|
      @grid.length.times do |col|
        pos = [row,col]
        @grid[row][col] = Tile.new(pos,@bombs)
      end
    end
  end

  def print_grid
    @grid.each {|row| puts row.join(" ") }
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def cascade(tile)
    neighbors = tile.neighbors.map{|neighbor| self[neighbor]}.reject(&:revealed)
    neighbors.each do |neighbor_tile|
      neighbor_tile.reveal
      cascade(neighbor_tile) if neighbor_tile.empty? # only flip neighbors of "empty" tiles
    end
  end

  def reveal(pos)
    picked_tile = self[pos]
    picked_tile.reveal
    if picked_tile.bombed # If it's a bomb, game over.
      @game_over = true
    elsif picked_tile.empty? # If it's an empty tile, reveal it and its neighbors
      cascade(picked_tile)
    end
  end

end
