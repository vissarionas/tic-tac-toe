COMPUTER_MARK = 'X'.freeze
USER_MARK = 'O'.freeze
ROW_WIDTH = 37
board = {}
available_positions = (1..9).to_a
current_player = USER_MARK
win_combinations = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9],
  [1, 4, 7], [2, 5, 8], [3, 6, 9],
  [1, 5, 9], [3, 5, 7]
]

def win_detected?(board, combinations)
  winner = nil
  combinations.each do |combination|
    testable = []
    combination.each { |num| testable << board[num] if board.key? num }
    win_detected = testable.length == 3 && testable.uniq.length == 1
    winner = testable[0] == 'O' ? 'USER' : 'COMPUTER' if win_detected
  end
  puts "#{winner} WON !!" if winner
  !winner.nil?
end

def possible_win(player, board, combinations)
  possible_win_position = nil
  combinations.each do |combination|
    under_test = board.select { |key, value| value if combination.include? key }
    possible_win = under_test.values.count(player) == 2
    possible_win_position = combination.drop_while { |key| under_test.keys.include? key } if possible_win
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

def computer_selection(board, positions, combinations)
  pc_winning_move = possible_win('X', board, combinations)
  user_winning_prevent = possible_win('O', board, combinations) unless pc_winning_move
  pc_winning_move || user_winning_prevent || positions.sample
end

def reduce_available_positions(available_positions, position)
  available_positions.delete position.to_i
end

def update_board(board, position, current_player)
  board[position.to_i] = current_player
end

def next_move(board, current_player, combinations, available_positions)
  if current_player == USER_MARK
    user_selection(available_positions)
  else
    sleep 1
    computer_selection(board, available_positions, combinations)
  end
end

def switch_player(current_player)
  current_player == USER_MARK ? COMPUTER_MARK : USER_MARK
end

def play(board, win_combinations, available_positions, current_player)
  next_move = next_move(board, current_player, win_combinations, available_positions)
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

loop do
  render_board(board)
  play(board, win_combinations, available_positions, current_player)
  break if win_detected?(board, win_combinations)

  current_player = switch_player(current_player)
end
