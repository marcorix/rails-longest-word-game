require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U)

  def new
    @letters = Array.new(4) { VOWELS.sample}
    @letters += Array.new(6) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    @included = included?(@word, @letters)
    @english_word = is_english?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? {|letter| word.count(letter) <= letters.count(letter)}
  end

  def is_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    res = URI.open(url).read
    data = JSON.parse(res)
    data["found"]
  end
end
