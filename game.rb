class Game
  attr_accessor :score, :map_columns, :map_lines, :map
  def initialize player
    @run = 0
    @map_columns = 12
    @map_lines = 6
    @map = Array.new(@map_lines){Array.new(@map_columns)}
    initialize_map
    @start_x = 1
    @start_y = 1
    @player = player
    reset

    # Clear the console
    # puts "\e[H\e[2J"

  end

  def initialize_map
    @map = [
      "############",
      "#=#========#",
      "#=#=##=###=#",
      "#=#=#==#===#",
      "#======#O#C#",
      "############"
    ].map{|line| line.split("")}
  end

  def reset
    @player.y = @start_y
    @player.x = @start_x
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
      @player.x -= 1 if @map[@player.y][@player.x-1] != "#"
    elsif move == :right
      @player.x += 1 if @map[@player.y][@player.x+1] != "#"
    elsif move == :up
      @player.y -= 1 if @map[@player.y-1][@player.x] != "#"
    elsif move == :down
      @player.y += 1 if @map[@player.y+1][@player.x] != "#"
    end

    if @map[@player.y][@player.x] == "C"
      @score += 1
      @player.x = @start_x
      @player.y = @start_y
    end

    if @map[@player.y][@player.x] == "O"
      @score -= 1
      @player.x = @start_x
      @player.y = @start_y
    end
  end

  def draw
    puts "\e[H\e[2J"
    map_table = []
    # Compute map line
    @map.each_with_index do |line,line_index|
      map_line = line.map.with_index do |col,col_index|
        if @player.x == col_index && @player.y == line_index
          'P'
        else
          @map[line_index][col_index]
        end
      end
      map_table << "\n\r#{map_line.join}"
    end
    # Draw to console
    # use printf because we want to update the line rather than print a new one
    print("#{map_table.join} | Score #{@score} | Run #{@run}\n")
    # printf("")
  end
end
