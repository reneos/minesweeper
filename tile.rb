class Tile

  def initialize(pos,bombs)
    @pos = pos
    @bombs = bombs
    @flagged = false
    @bombed = @bombs.include?(@pos)
    set_value
  end

  def set_value
    if @bombed
      @value = "B"
    else
      adjacent_bombs_num = self.bombs_adjacent
      if adjacent_bombs_num > 0
        @value = adjacent_bombs_num.to_s
      else
        @value = "*"
      end
    end
  end

  def bombs_adjacent
    adjacent_bombs_num = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        row, col = @pos
        if @bombs.include?([row+i, col+j])
          adjacent_bombs_num += 1
        end
      end
    end
    adjacent_bombs_num
  end

  def to_s
    @value
  end

end
