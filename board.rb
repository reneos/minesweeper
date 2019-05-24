require_relative './tile.rb'
require 'pry'

class Board

  attr_reader :grid, :bombs

  def initialize
    @grid = Array.new(9) {Array.new(9)}
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

end

board = Board.new

pry
