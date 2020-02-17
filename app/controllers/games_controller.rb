require 'open-uri'
require 'json'
require 'time'

class GamesController < ApplicationController
  def new
    char = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
    counter = 0
    @letters = []
    while counter < 10
      @letters << char.sample(1).join
      counter += 1
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @time = Time.parse(params[:time])
    @speed = Time.now

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    answer_serialized = open(url).read
    @answer = JSON.parse(answer_serialized)

    if @answer ['found'] == false
      @message = 'Not an English word!'
      @score = 0
    elsif @word.upcase.chars.all? { |let| @word.upcase.count(let) <= @letters.upcase.count(let) } == false
      @message = 'Not in the grid!'
      @score = 0
    else
      @message = 'Good job!'
      @score = ((@word.length * 10) - ((@speed - @time) / 60)).round(2)
    end
  end
end
