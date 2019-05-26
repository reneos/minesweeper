require_relative './board.rb'
require 'tty-cursor'
require 'tty-prompt'
require 'colorize'
require 'yaml'


class Game

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
      puts "Move around with arrow keys"
      puts "Press return to flip tile, tab to flag tile."
      puts "Press 's' to save and exit. Press 'l' to load saved game."
      mode, pos = self.prompt(cursor_pos)
      cursor_pos = pos
      if mode == "r"
        @board.reveal(pos)
      elsif mode == "f"
        @board.flag_tile(pos)
      elsif mode == "l"
        @board = YAML::load_file('save.yml')
        print "File loaded."
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
        elsif event.value == "s"
          File.open('save.yml','w') {|file| file.write(@board.to_yaml)}
          system("clear")
          print @cursor.move_to(0,0)
          puts "Game saved.".colorize(:red)
          exit
        elsif event.value == "l"
          return "l", [row,col]
        end
      end

      prompt.on(:keyescape) do |event|
        system("clear")
        print @cursor.move_to(0,0)
        exit
      end

      prompt.read_keypress
    end
  end

end

game = Game.new
game.run
