# frozen_string_literal: true
require_relative 'person.rb'
require_relative '../koans/about_dice_project'
require_relative '../koans/about_scoring_project'

class Game
  DICES_NUMBER = 5
  ENDING_PHASE = 500
  attr_accessor :name, :accumulated_score, :scored_three_hundreds

  def initialize
    puts("Добро пожаловать в GREED GAME\nИгроки, представтесь, пожалуйста. Когда все представятся, напишите 0. Первый игрок:\n")
    @players = Array.new(2)
    i = 0
    while true
      name = gets.chomp
      if name == "0"
        break
      end
      @players[i] = Person.new(name)
      puts("Отлично, теперь следующий игрок:\n")
      i += 1
    end

    @amount_of_players = @players.length
    @order = rand(0..@amount_of_players - 1)
    puts("Первым ходит игрок #{@players[@order].name}")

    game_proccess
  end

  def game_proccess
    game_continues = true
    game_ending = false
    countdown = @players.length + 1
    count_people_done_turn_in_round = 0
    while game_continues
      puts "\nХодит игрок #{@players[@order].name}"
      turn
      count_people_done_turn_in_round = (count_people_done_turn_in_round + 1) % @players.length

      if @players[@order].accumulated_score >= ENDING_PHASE && !game_ending
        puts "Игрок #{@players[@order].name} набрал #{ENDING_PHASE} или больше очков, все игроки делают последний ход."
        game_ending = true
        if count_people_done_turn_in_round > 0
          countdown += @players.length - count_people_done_turn_in_round
        end
      end

      if game_ending
        countdown -= 1
        if countdown == 0
          game_continues = false
          ending
        end
      end

      @order = (@order + 1) % @amount_of_players
    end
  end

  def ending
    winner = ""
    max_score = 0
    draw = false
    for player in @players
      if player.accumulated_score > max_score
        winner = player.name
        max_score = player.accumulated_score
        draw = false
      else
        if player.accumulated_score == max_score
          draw = true
          winner += "и #{player.name}"
        end
      end
    end

    line_first = "Победитель"
    line_second = "победителя"
    if draw
      line_first = "Победители"
      line_second = "победителей"
    end
    puts "\n#{line_first} GREED GAMES - #{winner}!\nПоздравляем #{line_second} и желаем удачи в следующих играх всем участвовшим!"

    for player in @players
      puts "#{player.name} - #{player.accumulated_score}"
    end
  end

  def turn
    puts "Бросок!"
    score, unused_dices = roll(DICES_NUMBER)
    if unused_dices == 0
      unused_dices = 5
    end
    @accumulated_score = score
    player_choice = 1
    while player_choice != 0
      puts "Если вы хотите перебросить кубики, которые не участвовали в наборе очков, то напишите 1. Если не хотите, то напишите 0"
      player_choice = gets.to_i
      if player_choice == 1
        score, unused_dices = roll(unused_dices)
        if score == 0
          puts "Ваш ход на этом заканчивается."
          @accumulated_score = 0
          break
        else
          @accumulated_score += score
          puts "За этот ход вы набрали уже #{@accumulated_score} очков!"
        end
      end
    end

    block_score = -> {
      @players[@order].accumulated_score += @accumulated_score
      puts "Всего у вас #{@players[@order].accumulated_score} очков!"
    }

    if @players[@order].scored_three_hundreds
      block_score.call
    elsif @accumulated_score >= 300
      @players[@order].scored_three_hundreds = true
      puts "Вы набрали 300 или больше очков, теперь для Вас начался подсчет."
      block_score.call
    else
      puts "Вы еще не набрали 300 или больше очков, продолжайте стараться"
    end

  end

  def roll(dices_number)
    dice = DiceSet.new
    dice.roll(dices_number)
    @rolled_dices = dice.values

    for num in dice.values
      print "#{num} "
    end
    results = score_modified(dice.values)
    if results[0] > 0
      puts "\nВы набрали #{results[0]} очков после броска!"
    else
      puts "\nК сожалению у вас 0 очков после броска."
    end
    results
  end
end

game = Game.new
