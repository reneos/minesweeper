require_relative './tile.rb'

class Board

  attr_reader :grid, :bombs, :size, :game_over

  def initialize
    @size = 15
    @grid = Array.new(@size) {Array.new(@size)}
    @bombs = []
    @lose = false
    fill_in_bombs
    fill_in_tiles
    print_grid
  end

  def fill_in_bombs
    num_bombs = @grid.flatten.length / 8
    until num_bombs == 0
      row, col = rand(0...@size), rand(0...@size)
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
        @grid[row][col] = Tile.new(pos,@bombs,@size)
      end
    end
  end

  def print_grid
    # originally used tty-box gem to draw the box, but it doesn't allow colorized text to be passed into it
    left_border = "║  "
    right_border = "  ║"
    corners = ["╔","╗","╚","╝"]
    top_border = "═" * (@size*2 - 8)
    bottom_border = "═" * (@size * 2 + 3)
    puts corners[0] + "MINESWEEPER" + top_border + corners[1]
    @grid.each_with_index do |row|
      puts left_border + "#{row.join(" ")}" + right_border
    end
    puts corners[2] + bottom_border + corners[3]
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

  def flag_tile(pos)
    self[pos].flag
  end

  def reveal(pos)
    picked_tile = self[pos]
    picked_tile.reveal
    if picked_tile.bombed # If it's a bomb, game over.
      @lose = true
    elsif picked_tile.empty? # If it's an empty tile, reveal it and its neighbors
      cascade(picked_tile)
    end
  end

  def win?
    @grid.flatten.reject(&:bombed).all?(&:revealed)
  end

  def lose?
    @lose
  end

  def game_over
    win? || lose?
  end

  def reveal_board
    @grid.each {|row| row.each(&:reveal) }
    print_grid
  end

end
