require './game.rb'
require './q_learning_player.rb'

reuse = ARGV[0] != "false"
p = QLearningPlayer.new(reuse)
g = Game.new( p )
p.game = g

10.times do
  g.run
  g.reset
end

File.open("p_table", "w+") do |f|
  p.q_table.each do |line|
    f.puts line.join(",")
  end
end
puts ""
