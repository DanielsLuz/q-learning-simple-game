class QLearningPlayer
  attr_accessor :x, :y, :game, :q_table

  def initialize(reuse_learned=true)
    @x = 1
    @y = 1
    @actions = [:left, :right, :up, :down]
    @first_run = true

    @learning_rate = 0.2
    @discount = 0.9
    @epsilon = 0.9
    @reuse_learned = reuse_learned

    @r = Random.new
  end

  def initialize_q_table
    # Initialize q_table states by actions
    @q_table = Array.new(@game.map_lines){
      Array.new(@game.map_columns){ Array.new(@actions.length) }
    }

    # if true || @reuse_learned
    if @reuse_learned
      table = []
      File.readlines('./p_table').each do |line|
        table << line.split(",").map(&:to_f).each_slice(4).to_a
      end
      @q_table = table
    else
    # Initialize to random values
      @game.map_lines.times do |l|
        @game.map_columns.times do |s|
          @actions.length.times do |a|
            @q_table[l][s][a] = @r.rand
          end
        end
      end
    end
  end

  def get_input
    # Pause to make sure humans can follow along
    sleep 0.05

    if @first_run
      # If this is first run initialize the Q-table
      initialize_q_table
      @first_run = false
    else
      # If this is not the first run
      # Evaluate what happened on last action and update Q table
      # Calculate reward
      r = 0 # default is 0
      if @old_score < @game.score
        r = 1 # reward is 1 if our score increased
      elsif @old_score > @game.score
        r = -1 # reward is -1 if our score decreased
      end

      if position_not_changed
        @q_table[@old_y][@old_x][@action_taken_index] = 0
      else
        # Our new state is equal to the player position
        @q_table[@old_y][@old_x][@action_taken_index] = @q_table[@old_y][@old_x][@action_taken_index] + @learning_rate *
          (r + @discount * @q_table[@y][@x].max - @q_table[@old_y][@old_x][@action_taken_index])
      end
    end

    # Capture current state and score
    @old_score = @game.score
    @old_y = @y
    @old_x = @x

    # Chose action based on Q value estimates for state
    if @r.rand > @epsilon
      # Select random action
      @action_taken_index = @r.rand(@actions.length).round
    else
      # Select based on Q table
      @action_taken_index = @q_table[@y][@x].each_with_index.max[1]
    end

    # print_table
    # Take action
    return @actions[@action_taken_index]
  end

  def print_table
    @q_table.each do |line|
      line.each do |col|
        puts col.map {|ac| ac.round(2)}.join", "
      end
      puts "\n"
    end
  end

  private

  def position_not_changed
    @x == @old_x && @y == @old_y
  end

end
