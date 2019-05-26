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
      @board.print_grid
      print_instructions
      mode, pos = self.prompt(cursor_pos)
      cursor_pos = pos # save the cursor position
      if mode == "r"
        @board.reveal(pos)
      elsif mode == "f"
        @board.flag_tile(pos)
      elsif mode == "l"
        @board = YAML::load_file('save.yml')
        puts "Loading saved game."
        sleep(2)
      end
    end
    game_over_message
  end

  def print_instructions
    s = "s".colorize(:blue)
    l = "l".colorize(:blue)
    enter_key = "return".colorize(:blue)
    arrows = "arrow keys".colorize(:blue)
    tab = "tab".colorize(:blue)
    escape = "escape".colorize(:blue)
    puts "Move around with #{arrows}."
    puts "Press #{enter_key} to flip tile, #{tab} to flag or unflag a tile."
    puts "Press #{s} to save and exit. Press #{l} to load saved game."
    puts "Press #{escape} to quit."
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

  def save_game
    File.open('save.yml','w') {|file| file.write(@board.to_yaml)}
    system("clear")
    print @cursor.move_to(0,0)
    puts "Game saved. Exited game.".colorize(:red)
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
          save_game
          exit
        elsif event.value == "l"
          return "l", [row,col]
        elsif key == :escape
          system("clear")
          print @cursor.move_to(0,0)
          puts "Exited game."
          exit
        end
      end

      prompt.read_keypress
    end
  end

end

game = Game.new
game.run
