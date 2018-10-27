class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(char)
    if /[a-zA-Z]{1}/.match(char) == nil
      raise ArgumentError
    end
    char.downcase!
    if @word.rindex(char) != nil
      if @guesses.rindex(char) != nil
        return false
      else
        guesses << char
        return true
      end
    else
      if @wrong_guesses.rindex(char) != nil
        return false
      else
        wrong_guesses << char
        return true
      end
    end
  end

  def word_with_guesses
    displayed = word
    word_a = word.chars
    word_a.each do |char|
      if guesses.index(char) == nil
        displayed.gsub!(char, "-")
      end
    end
    return displayed
  end

  def check_win_or_lose
    if self.word_with_guesses.index("-") == nil
      :win
    elsif wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end
      
end
