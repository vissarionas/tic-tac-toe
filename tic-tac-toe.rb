COMPUTER_MARK = 'X'
USER_MARK = 'O'
ROW_WIDTH = 37
WIN_COMBINATIONS = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9],
  [1, 4, 7], [2, 5, 8], [3, 6, 9],
  [1, 5, 9], [3, 5, 7]
].freeze
current_player = USER_MARK
board = {}
available_positions = (1..9).to_a
winner = nil

def play_again?
  puts 'Play again? (Y/N)'
  user_input = gets.chomp.upcase
  user_input == 'Y'
end

def present_winner(winner)
  puts "#{winner} WON!!"
end

def detect_winner(board)
  winner = nil
  WIN_COMBINATIONS.each do |combination|
    under_test = board.select { |key, value| value if combination.include? key }.values
    win_detected = under_test.length == 3 && under_test.uniq.size == 1
    winner = under_test[0] == USER_MARK ? 'USER' : 'COMPUTER' if win_detected
  end
  winner
end

def possible_win(player, board)
  possible_win_position = nil
  WIN_COMBINATIONS.each do |combination|
    under_test = board.select { |key, value| value if combination.include? key }
    possible_win = under_test.values.count(player) == 2
    possible_win_position = combination.reject { |key| under_test.keys.include? key } if possible_win
  end
  possible_win_position[0] if possible_win_position
end

def render_row(row_start, row_end, board)
  5.times do |time|
    row = '|'
    row_start.upto row_end do |num|
      input = time == 2 ? board[num].to_s : ''
      row += "#{(input.center 11).prepend}|"
    end
    puts row
  end
end

def render_board_separator
  puts '-' * ROW_WIDTH
end

def user_selection(positions)
  loop do
    print 'Choose your position: '
    position = gets.chomp.to_i
    return position if positions.include? position
  end
end

def computer_selection(board, positions)
  pc_winning_move = possible_win('X', board)
  user_winning_prevent = possible_win('O', board) unless pc_winning_move
  pc_winning_move || user_winning_prevent || positions.sample
end

def reduce_available_positions(available_positions, position)
  available_positions.delete position.to_i
end

def update_board(board, position, current_player)
  board[position.to_i] = current_player
end

def next_move(board, current_player, available_positions)
  if current_player == USER_MARK
    user_selection(available_positions)
  else
    sleep 1
    computer_selection(board, available_positions)
  end
end

def switch_player(current_player)
  current_player == USER_MARK ? COMPUTER_MARK : USER_MARK
end

def play(board, available_positions, current_player)
  next_move = next_move(board, current_player, available_positions)
  update_board(board, next_move, current_player)
  reduce_available_positions(available_positions, next_move)
  render_board(board)
end

def render_board(board)
  system 'clear'
  puts 'TicTacToe!'
  render_row(1, 3, board)
  render_board_separator
  render_row(4, 6, board)
  render_board_separator
  render_row(7, 9, board)
end

def reset_game(board, available_positions, current_player)
  board.clear
  available_positions.replace((1..9).to_a)
  current_player.replace 'O'
end

loop do
  loop do
    render_board(board)
    play(board, available_positions, current_player)
    winner = detect_winner(board)
    break if winner

    current_player = switch_player(current_player)
  end
  present_winner(winner)
  reset_game(board, available_positions, current_player) if winner
  break reset_game(board, available_positions, current_player) unless play_again?
end
