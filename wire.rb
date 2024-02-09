########################################################################
# Wireworld Valentine Challenge
# Objective: Implement Wireworld and create a Valentine circuit!
# Start Date: February 2, 2023
# End Date: February 14, 2023
# 
# Author: darksaoixus
########################################################################

# Mixin abominations
# Yes, I do love mixins :3
module KeyFromValue
  def key_from_value(value)
    self.each do |key, val|
      return key if val == value
    end
  end
end

class Hash
  include KeyFromValue
end

module Distance
  def dist(n)
    (self - n).abs
  end
end

class Numeric
  include Distance
end

########################################################################
class Wireworld
  EMPTY         = "🟪"
  ELECTRON_HEAD = "🟥"
  ELECTRON_TAIL = "⬜"
  CONDUCTOR     = "🟨"
  WALL          = "🔳"

  CONVERSION_HASH = {
    "x" => EMPTY,
    "O" => ELECTRON_HEAD,
    "." => ELECTRON_TAIL,
    "=" => CONDUCTOR,
    "W" => WALL,
  }

  def initialize(filename)
    @grid = [[]]
    @frame_data = []
    @handled_heads = {}

    file_to_grid(filename)
  end

  def file_to_grid(filename)
    begin
      File.open(filename, "r") do |file|
        @grid = file.readlines(chomp: true).map do |line|
          line.chars.map do |char|
            CONVERSION_HASH.fetch(char, EMPTY)
          end
        end
      end
    rescue Errno::ENOENT
      puts "File: #{filename} does not exist."
      exit
    rescue => e
      puts "Error: #{e}"
    end

    @rows = @grid.length
    @cols = @grid[0].length

    update_frame_data
  end

  def update_frame_data
    @frame_data.replace(@grid.map { |row| row.dup })
  end

  def clear_screen
    system("clear") or system("cls")
  end

  def display
    puts @grid.collect(&:join)
  end

  def check_neighbors(data, row, col)
    tx = ty = 0
    neighbor_conductors = []
    found_wall = false

    (row-1..row+1).each do |r|
      next if r < 0 or r >= @rows #invalid

      (col-1..col+1).each do |c|
        next if c < 0 or c >= @cols #invalid
        next if r == row and c == col #current cell
        
        case @frame_data[r][c]
        when ELECTRON_TAIL
          ty, tx = r, c
        when CONDUCTOR
          neighbor_conductors << [r, c] 
        when WALL
          found_wall = true
        end
      end
    end
    
    if found_wall
      @grid[ty][tx] = ELECTRON_HEAD
      @handled_heads[ty] = tx
      update_frame_data
    else
      neighbor_conductors.each do |nc|
        nc_y, nc_x = nc[0], nc[1]
      
        if nc_x.dist(tx) > 1 or nc_y.dist(ty) > 1
          @grid[nc_y][nc_x] = ELECTRON_HEAD
        end
      end
    end
  end

  def tick
    update_frame_data.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        case cell
        when ELECTRON_TAIL
          @grid[i][j] = CONDUCTOR
        when ELECTRON_HEAD
          if @handled_heads[i] != j
            @grid[i][j] = ELECTRON_TAIL
            check_neighbors(@frame_data, i, j)
          end
        end
      end
    end
    @handled_heads.clear
  end
  
  def run()
    loop do
      clear_screen
      display
      tick
      sleep 0.5
    end
  end

  """
  def run
    loop do
      display
      tick
      sleep 1
    end
  end
  """
  
  def grid_to_file(filename)
    File.open(filename, "w") do |file|
      converted_grid = @grid.map do |row|
        row.map do |cell|
          CONVERSION_HASH.key_from_value(cell)
        end
      end

      file.puts converted_grid.collect(&:join)
    end
  end
end

if __FILE__ == $0
  game = Wireworld.new("levels/test.txt")
  game.run
end

