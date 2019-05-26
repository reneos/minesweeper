require_relative './board.rb'
require 'pry'
require 'tty'
require 'remedy'
include Remedy

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def print_box(contents)
    box = TTY::Box.frame(
      width: 25,
      height: 12,
      title: {top_left: 'MINESWEEPER'},
      border: :thick,
      align: :center) do
        contents
      end
    puts box
  end

  def run
    @cursor = TTY::Cursor
    until @board.game_over
      system("clear")
      print_box(@board.print_grid)
      mode, pos = self.prompt
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
    print_box(@board.reveal_board)
    puts message
  end

  def prompt
    print @cursor.show
    print @cursor.move_to(5,2)
    row = 0
    col = 0
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
          print @cursor.backward(2)
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
