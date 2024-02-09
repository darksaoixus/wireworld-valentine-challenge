require_relative "wire"

$game = Wireworld.new("levels/test.txt")
$level_files = []
$error_msg = ""

Dir.foreach("levels") do |entry|
  full_path = File.join("levels", entry)
  if File.file?(full_path)
    $level_files << full_path
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

  begin
    n_opt = Integer(opt)
    if n_opt < 0 or n_opt >= $level_files.length
      $error_msg = "'#{n_opt}' is not a valid option"
      return
    end

    $game.file_to_grid($level_files[n_opt])
    $game.run
  rescue ArgumentError
    $error_msg = "'#{opt}' is not a number"
  end
end

loop do
  screen
  $game.clear_screen
end

