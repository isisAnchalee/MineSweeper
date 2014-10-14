# encoding: UTF-8

require 'yaml'
require_relative 'board.rb'
require_relative 'tile.rb'

class Game
  class InputError < StandardError
  end

  CHOICES = %w(S F R)

  attr_accessor :mine_field

  def new_or_saved_game?
    puts "Type 'new' to play a new game."
    puts "Type 'load' to load an existing game."

    if gets.chomp == 'new'
      @mine_field = Board.new
      play_game(mine_field)
    else
      old_game_file = File.open('saved_game', 'r')
      old_game_board = YAML.load(old_game_file)
      @mine_field = old_game_board
      play_game(mine_field)
    end
  end

  def prompt_user
    print '(F)lag, (R)eveal, (S)ave: '
    choice = gets.chomp.upcase
    raise InputError.new('Not a Valid Input') unless validate_input?(choice)
    choice
  rescue InputError => error
    puts error
    retry
  end

  def validate_input?(choice)
    CHOICES.include?(choice)
  end

  def play_game(game_board)
    
    until game_over? || won?
      game_board.display_board
      choice = prompt_user
      choice_handler(choice)
    end
    
    end_game_prompt(game_board)
  end

  def end_game_prompt(game_board)
    game_board.display_complete_board

    if won?
      puts 'You have de-minded the field!'
    else
      puts "-------------------"
      puts '      💣 Boom!'
      puts "  You lost a #{ %w(head arm leg poop eye face).sample }."
      puts "-------------------"
    end
  end

  def choice_handler(choice)
    if choice == 'F'
      x, y = get_coords
      @mine_field.grid[x][y].flag_tile
    elsif choice == 'R'
      x, y = get_coords
      @mine_field.grid[x][y].reveal_tile
    else
      save_game
    end
  end

  def get_coords
    print "Enter each 'x y' coordinate with a space between: "
    coords = gets.split(' ').map(&:to_i)

    unless @mine_field.validate_coordinate(coords)
      raise InputError.new('Not a Valid Coordinate')
    end

    coords
  rescue InputError => error
    puts error
    retry
  end

  def game_over?
    @mine_field.tiles.any? { |tile| tile.bomb && tile.revealed }
  end

  def revealed_bomb(row, col)
    @mine_field.grid[row][col].bomb && @mine_field.grid[row][col].revealed
  end

  def won?
    flagged_bombs = 0
    
    @mine_field.tiles.each do |tile| 
      flagged_bombs += 1 if tile.bomb && tile.flag
    end
  
    flagged_bombs == @mine_field.bomb_count
  end

  def save_game
    File.open('saved_game', 'w') do |f|
      f.print mine_field.to_yaml
    end
    puts 'Game Saved!'
  end
end

Game.new.new_or_saved_game?
