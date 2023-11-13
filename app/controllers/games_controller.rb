require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    alphabet = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]
    10.times do
      @letters << alphabet.sample
    end

  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    if @included && @english_word
      @score = @word.length
      @message = "Congratulations! #{@word} is an English word !"
    elsif @included && !@english_word
      @score = 0
      @message = "Sorry but #{@word} is not an English word."
    else !@included
      @score = 0
      @message = "Sorry but #{@word} can't be built out of #{@letters}"
    end
  end

  def included?(word, letters)
    word.chars.all? do |char|
      word.count(char) <= letters.count(char)
    end
  end

  def english_word?(word)
    dictionary = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(dictionary.read)
    json['found']
  end

end
