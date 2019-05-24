require_relative './board.rb'
require 'colorize'
require 'pry'

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def run
    until @board.game_over
      pos = self.prompt
      @board.reveal(pos)
      @board.print_grid
    end
    if @board.win?
      puts "You win!"
    else
      puts "You lose!"
    end
    @board.reveal_board
  end

  def prompt
    input = ""
    until input.length == 2 && input.all? {|ele| ele < @board.size}
      print "Enter a coordinate in row, col format: "
      input = gets.chomp.split(",").map(&:to_i)
    end
    input
  end

end

game = Game.new
game.run


pry
