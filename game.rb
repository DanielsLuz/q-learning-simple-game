class Game
  attr_accessor :score, :map_size, :map_lines
  def initialize player
    @run = 0
    @map_size = 12
    @map_lines = 4
    @start_position = 3
    @player = player
    reset

    # Clear the console
    # puts "\e[H\e[2J"

  end

  def reset
    @player.x = @start_position
    @cheese_x = 10
    @cheese_y = 2
    @pit_x = 0
    @pit_y = 1
    @score = 0
    @run += 1
    @moves = 0
  end

  def run
    while @score < 5 && @score > -5
      draw
      gameloop
      @moves += 1
    end

    # Draw one last time to update the
    draw

    if @score >= 5
      puts "  You win in #{@moves} moves!"
    else
      puts "  Game over"
    end

  end

  def gameloop
    move = @player.get_input
    if move == :left
      @player.x = if @player.x > 0
                    @player.x-1 
                  elsif @player.x == 0 
                    0
                  end
    elsif move == :right
      @player.x = if @player.x < @map_size-1 
                    @player.x+1 
                  elsif @player.x == @map_size-1
                    @map_size-1
                  end
    elsif move == :up
      @player.y = if @player.y > 0
                    @player.y-1 
                  elsif @player.y == 0 
                    0
                  end
    elsif move == :down
      @player.y = if @player.y < @map_lines-1 
                    @player.y+1 
                  elsif @player.y == @map_lines-1
                    @map_lines-1
                  end
    end

    if @player.x == @cheese_x && @player.y == @cheese_y
      @score += 1
      @player.x = @start_position
    end

    if @player.x == @pit_x && @player.y == @pit_y
      @score -= 1
      @player.x = @start_position
    end
  end

  def draw
    puts "\e[H\e[2J"
    map_table = []
    # Compute map line
    @map_lines.times do |j|
      map_line = @map_size.times.map do |i|
        if @player.x == i && @player.y == j
          'P'
        elsif @cheese_x == i && @cheese_y == j
          'C'
        elsif @pit_x == i && @pit_y == j
          'O'
        else
          '='
        end
      end
      map_table << "\n\r##{map_line.join}#"
    end
    # Draw to console
    # use printf because we want to update the line rather than print a new one
    print("#{map_table.join} | Score #{@score} | Run #{@run}\n")
    # printf("")
  end
end
