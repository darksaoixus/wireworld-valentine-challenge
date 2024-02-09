require_relative "wire"

$game = Wireworld.new("levels/test.txt")
$level_files = []
$error_msg = ""

def parse_level_folder
  Dir.foreach("levels") do |entry|
    full_path = File.join("levels", entry)
    if File.file?(full_path)
      $level_files << full_path
    end
  end
end

def print_levels
  $level_files.each_with_index do |level, i|
    puts "#{i}. #{level}"
  end
end

def screen
  puts "Wireworld Valentine Challenge"
  puts "by saoixus".rjust(29)
  puts "-" * 29
  print_levels
  if not $error_msg.empty?
    puts "\n#{$error_msg}"
  end
  print "Type the level's number to run it: "
  opt = gets.chomp
  return opt
end

def handle_opt(opt)
  ret = -1
  begin
    n_opt = Integer(opt)
    if n_opt < 0 or n_opt >= $level_files.length
      $error_msg = "'#{n_opt}' is not a valid option"
    else
      ret = n_opt
    end
  rescue ArgumentError
    $error_msg = "'#{opt}' is not a number"
  end

  return ret
end

if __FILE__ == $0
  parse_level_folder

  loop do
    n_opt = handle_opt(screen)
    if n_opt != -1
      $game.file_to_grid($level_files[n_opt])
      $game.run
    end
    $game.clear_screen
  end
end

