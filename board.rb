require_relative './tile.rb'

class Board

  attr_reader :grid, :bombs, :size

  def initialize
    @size = 9
    @grid = Array.new(@size) {Array.new(@size)}
    @bombs = []
    fill_in_bombs
    fill_in_tiles
    print_grid
  end

  def fill_in_bombs
    num_bombs = @grid.flatten.length / 6
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

  def game_over?
    @bombs.any? do |bomb_pos|
      self[bomb_pos].revealed
    end
  end

  def cascade(tile)
    if !(tile.revealed)
      tile.reveal
      if !(tile.neighbors.empty?)
        neighbors = tile.neighbors.map{|neighbor| self[neighbor]}
        neighbors.each do |neighbor|
          if "12345678".include?(neighbor.value)
            neighbor.reveal
          else
            cascade(neighbor)
          end
        end
      end
    end
  end

  def reveal(pos)
    picked_tile = self[pos]
    #If it's a bomb, stop there. If not, cascade.
    if picked_tile.value != "B" && !"12345678".include?(picked_tile.value)
      cascade(picked_tile)
    else
      picked_tile.reveal
    end
  end

end
