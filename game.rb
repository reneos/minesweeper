require_relative './board.rb'
require 'pry'
require 'tty-cursor'
require 'tty-prompt'
require 'colorize'


class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def run
    @cursor = TTY::Cursor
    cursor_pos = [0,0]
    until @board.game_over
      system("clear")
      # print_box(@board.print_grid)
      @board.print_grid
      print "Move around with arrow keys. Enter to flip tile, tab to flag tile."
      mode, pos = self.prompt(cursor_pos)
      cursor_pos = pos
      if mode == "r"
        @board.reveal(pos)
      else
        @board.flag_tile(pos)
      end
    end
    game_over_message
  end

  def game_over_message
    system("clear")
    if @board.win?
      message = "You win!"
    else
      message = "You lose!"
    end
    @board.reveal_board
    puts message
  end

  def prompt(current_pos)
    row, col = current_pos
    print @cursor.show
    print @cursor.move_to(col + col + 3, row + 1) # double col value to account for space printed in grid for readability
    while true
      prompt = TTY::Prompt::new(interrupt: :exit)
      prompt.on(:keypress) do |event|
        key = event.key.name
        print @cursor.save
        if key == :down
          print @cursor.down(1)
          row += 1
        elsif key == :up
          print @cursor.up(1)
          row -= 1
        elsif key == :left
          print @cursor.backward(2) # move 2 spaces for lateral movement due to space printed in grid for readability
          col -= 1
        elsif key == :right
          print @cursor.forward(2)
          col += 1
        elsif key == :return
          return "r", [row,col]
        elsif key == :tab
          return "f", [row,col]
        end
      end

      prompt.on(:keyescape) do |event|
        exit
      end

      prompt.read_keypress
    end
  end

end

game = Game.new
game.run


pry
