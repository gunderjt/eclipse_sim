class StaticPagesController < ApplicationController
  require_or_load 'battle.rb'
  

  def home
  end
  def calculate
    @battle = JSON.parse params[:fleet]
    results = []
    num_of_battles = 100
    for i in 1..num_of_battles
      battle = create_battle(@battle)
      while !(win = battle.winner?)
        battle.one_round()
      end
      results.push(win.side)
    end
    att_wins = 0
    results.each do |side|
      if side == 'att'
        att_wins+=1
      end
    end 
    render text: "Attacking fleet wins #{att_wins} out of #{num_of_battles}"
  end
end
