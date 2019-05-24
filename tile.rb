class Tile

  attr_reader :revealed, :value, :neighbors, :bombed

  def initialize(pos,bombs)
    @pos = pos
    @bombs = bombs
    @flagged = false
    @revealed = false
    @bombed = @bombs.include?(@pos)
    @neighbors = [] # row, col coordinates of non-bombed neigbours
    set_value
  end

  def reveal
    @revealed = true
  end

  def empty?
    return @value == "_"
  end

  def set_value
    if @bombed
      @value = "B"
    else
      adjacent_bombs_num = self.bombs_adjacent
      if adjacent_bombs_num > 0
        @value = adjacent_bombs_num.to_s
        @neighbors = [] # don't need to know neighbors for numbered tiles
      else
        @value = "_"
      end
    end
  end

  def bombs_adjacent
    adjacent_bombs_num = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        next if i == 0 && j == 0 # don't look for self
        row, col = @pos
        row += i
        col += j
        if @bombs.include?([row, col])
          adjacent_bombs_num += 1
        elsif (0...9).include?(row) && (0...9).include?(col)
          @neighbors << [row, col]
        end
      end
    end
    adjacent_bombs_num
  end

  def flag # toggle whether tile is flagged by user
    @flagged = !@flagged
  end

  def to_s
    if @revealed
      if @bombed
        @value.colorize(:red)
      elsif !self.empty?
        @value.colorize(:light_blue)
      else
        @value
      end
    elsif @flagged
      "^"
    else
      @value
    end
  end

end
