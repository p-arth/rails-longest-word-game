require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @start_time = Time.now.to_i
  end

  def validator
    @validator = true
    params[:word] = params[:word].upcase.split('')
    params[:letters] = params[:letters].split(' ')
    params[:word].each do |letter|
      if params[:letters].include?(letter)
        params[:letters].delete_at(params[:letters].index(letter))
      else
        @validator = false
      end
    end
    @validator
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @time_elapsed = Time.now - Time.parse(params[:start_time])
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    answer = JSON.parse(open(url).read)
    if answer['found'] && validator
      @score = "Your score is #{answer['length'] * 10 / @time_elapsed.to_i}"
    else
      @score = 'Not a valid word'
    end
  end
end
