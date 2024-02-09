require_relative "screen"

parse_level_folder

loop do
  n_opt = handle_opt(screen)
  if n_opt != -1
    $game.file_to_grid($level_files[n_opt])
    $game.debug_run
  end
  $game.clear_screen
end

