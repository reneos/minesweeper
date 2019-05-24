class Tile

  def initialize(pos,bombs)
    @pos = pos
    @bombs = bombs
    @flagged = false
    @revealed = true
    if @bombs.include?(pos)
      @value = "B"
    else
      @value = "_"
    end
  end

  def to_s
    if @flagged
      'F'
    elsif !@revealed
      '*'
    else
      @value
    end
  end

end
