require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    grid_h = {}
    @letters.each { |letter| grid_h[letter].nil? ? grid_h[letter] = 1 : grid_h[letter] += 1 }
    attempt_h = {}
    @word.chars.each { |letter| attempt_h[letter].nil? ? attempt_h[letter] = 1 : attempt_h[letter] += 1 }
    @ok = true
    @word.chars.each { |letter| @ok = false if grid_h[letter].nil? || grid_h[letter] < attempt_h[letter] }
    @english_word = english_word?(@word)
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

end
