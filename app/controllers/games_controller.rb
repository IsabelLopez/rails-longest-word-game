require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = 8.times.map { alphabet.sample }
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    json_raw = open(url).read
    json = JSON.parse(json_raw)
    # raise
    @result = {}
    @result[:message] = 'Not an english word'
    @result[:score] = 0
    if json['found'] == true
      base_freq = letter_frequency(params[:letters])
      attempt_freq = letter_frequency(@word.split(''))
      if calculate_score?(base_freq, attempt_freq)
      @result[:message] = 'Well done'
      # puts "calc score"
      @result[:score] = (@word.length * 10)
      else
        # puts "returns 0"
        @result[:message] = 'Not in the grid'
        @result[:score] = 0
      end
    end
    @result
  end

  def letter_frequency(array)
    hash = {}
    @word = params[:word].split('')
    # raise
    # @word.split("")
    @word.each do |letter|
      if hash.key?(letter)
        hash[letter] += 1
      else
        hash[letter] = 1
      end
    end

    hash
  end

  def calculate_score?(base_freq, attempt_freq)
    result = true
    attempt_freq.each do |letter, num|
      if base_freq.key?(letter) && base_freq[letter] >= num
        result
      else
        # puts "not good"
        result = false
        return result
      end
    end
  end
end
