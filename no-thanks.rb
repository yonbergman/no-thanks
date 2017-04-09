class Player
  def initialize
  end

  def reset(player_count = 4)
    @cards = []
    @token_count = 11
    self
  end

  def score
    card_score - @token_count
  end

  def take_card(card, tokens)
    @cards << card
    @token_count += tokens
  end

  def lose_token
    @token_count -= 1
  end

  def has_tokens?
    @token_count > 0
  end

  private

  def card_score
    sum = 0
    last_num = nil
    @cards.sort.each do |i|
      if last_num != i-1
        sum += i
      end
      last_num = i
    end
    sum
  end

end


class Game

  def initialize(player_count)
    @players = player_count.times.map {Player.new()}
  end

  def setup
    @deck = (3...35).to_a.shuffle
    @deck.pop(9)
    @players.each {|p| p.reset(@players.count) }
    @current_player = -1
    new_round
    self
  end

  def new_round
    return end_game if @deck.empty?
    @current_card = @deck.pop
    @current_tokens = 0
    next_player
    self
  end

  def end_game
    @players.each_with_index do |player, idx|
      print "Player #{idx} scored #{player.score}"
    end
  end

  def no_thanks
    return take unless current_player.has_tokens?
    current_player.lose_token
    @current_tokens += 1
    next_player
    self
  end

  def take
    current_player.take_card(@current_card, @current_tokens)
    new_round
    self
  end

  def current_player
    @players[@current_player]
  end

  def next_player
    @current_player = (@current_player + 1) % @players.count
  end

end
