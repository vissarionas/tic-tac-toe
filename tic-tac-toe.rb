COMPUTER_MARK = 'X'
USER_MARK = 'O'
selections_state = {}
available_positions = (1..9).to_a
current_player = 'O'
win_combinations = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9],
  [1, 4, 7], [2, 5, 8], [3, 6, 9],
  [1, 5, 9], [3, 5, 7]
]

def win_detected?(state, combinations)
  winner = nil
  combinations.each do |combination|
    testable = []
    combination.each { |num| testable << state[num] if state.key? num }
    win_detected = testable.length == 3 && testable.uniq.length == 1
    winner = testable[0] == 'O' ? 'USER' : 'COMPUTER' if win_detected
  end
  puts "#{winner} WON !!" if winner
  !winner.nil?
end

def possible_win?(player, state, combinations)
  position = nil
  combinations.each do |combination|
    testable = []
    combination.each { |num| testable << state[num] if state.key? num }
    possible_win_detected =
      testable.length == 2 &&
      testable.uniq.length == 1 &&
      testable[0] == player
    position = combination.dup if possible_win_detected
  end
  position&.reject! { |num| state.key? num }
  position[0] if position
end

def render_row(row_start, row_end, state)
  5.times do |time|
    row = '|'
    row_start.upto row_end do |num|
      input = time == 2 ? state[num].to_s : ''
      row += "#{(input.center 11).prepend}|"
    end
    puts row
  end
end

def user_selection(positions)
  loop do
    print 'Choose your position: '
    position = gets.chomp.to_i
    return position if positions.include? position
  end
end

def computer_selection(state, positions, combinations)
  pc_winning_move = possible_win?('X', state, combinations)
  user_winning_prevent = possible_win?('O', state, combinations)
  pc_winning_move || user_winning_prevent || positions.sample
end

def update_state_and_positions(state, combinations, positions, mark)
  position =
    if mark == USER_MARK
      user_selection(positions)
    else
      computer_selection(state, positions, combinations)
    end
  state[positions.delete position.to_i] = mark
end

def play(state, combinations, positions, player)
  sleep 1 if player == COMPUTER_MARK
  update_state_and_positions(state, combinations, positions, player)
  render_board(state)
end


def render_board(state)
  system 'clear'
  puts 'TicTacToe!'
  render_row(1, 3, state)
  puts '-' * ROW_WIDTH
  render_row(4, 6, state)
  puts '-' * ROW_WIDTH
  render_row(7, 9, state)
end

loop do
  render_board(selections_state)
  play(selections_state, win_combinations, available_positions, current_player)
  break if win_detected?(selections_state, win_combinations)

  current_player = current_player == 'O' ? 'X' : 'O'
end
