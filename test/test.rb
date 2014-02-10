require_relative '../parts.rb'
require_relative '../optimal_usage.rb'
require_relative '../battle.rb'
require_relative '../ship.rb'
require 'ruby-debug'

def test()
=begin
dieA = Die.new(1,2,3)
dieB = Die.new(2,2,3)
array1 = [dieA, dieB]
array2 = [dieA]
puts array1 -array2
'Tests'
/* Input data == correct array */

/* [4,2,2] : 3 == 4 */
/* 4,2,2 : 4 == 4 */
/* 4,2,2,1 : 4 == 4 */
/* 4,2,2,1 : 6 == 4,2 */
/* 4,2,2,1 : 7 == 4,2,1 */
/* 4,4,2,2,1 : 8 == 4,4 */
/* 4,2,2,1 : 8 == 4,2,2 */
=end
  initializeTiers = 2
  'TestA: [4,2,1] : 3 == 2,1'
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6)]
  yellow = [Die.new(3,1,3)]
  poolA = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcomeA = optimal_die_usage(poolA, 3)
  if testPass(outcomeA, 0, 1, 0, 0,[Die.new(2,2,6), Die.new(3,1,3)])
    puts "TestA : pass"
  else
    puts "TestA : fail"
  end


   'TestB: 4,2,2 : 4 == 2,2'
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = []
  poolB = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcomeB = optimal_die_usage(poolB, 4)
  if testPass(outcomeB, 0, 0, 2, 0,[Die.new(1,4,2)])
    puts "TestB : pass"
  else
    puts "TestB : fail"
  end

   'Testc: 4,2,2,1 : 4 == 2,2,1'
  shipDefense = 4
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = [Die.new(4,1,3)]
  pool = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcome = optimal_die_usage(pool, shipDefense)
  if testPass(outcome, 0, 0, 2, 1,[Die.new(1,4,2)])
    puts "TestC : pass"
  else
    puts "TestC : fail"
  end

  '4,2,2,1 : 6 == 2,1'
  shipDefense = 6
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = [Die.new(4,1,3)]
  pool = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcome = optimal_die_usage(pool, shipDefense)
  if testPass(outcome, 0, 0, 1, 1,[Die.new(1,4,2), Die.new(3,2,3)])
    puts "TestD : pass"
  else
    puts "TestD : fail"
  end

  '4,2,2,1 : 7 == 2'
  shipDefense = 7
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = [Die.new(4,1,3)]
  pool = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcome = optimal_die_usage(pool, shipDefense)
  if testPass(outcome, 0, 0, 1, 0, [Die.new(1,4,2), Die.new(3,2,3), Die.new(4,1,3)])
    puts "TestE : pass"
  else
    puts "TestE : fail"
  end

  '4,4,2,2,1 : 8 == 2,2,1'
  shipDefense = 8
  red = [Die.new(1,4,2), Die.new(5,4,5)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = [Die.new(4,1,3)]
  pool = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcome = optimal_die_usage(pool, shipDefense)
  if testPass(outcome, 0, 0, 2, 1, [Die.new(1,4,2), Die.new(5,4,5)])
    puts "TestF : pass"
  else
    puts "TestF : fail"
  end

  '4,2,2,1 : 8 == 1'
  shipDefense = 8
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = [Die.new(4,1,3)]
  pool = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcome = optimal_die_usage(pool, shipDefense)
  if testPass(outcome, 0, 0, 0, 1, [Die.new(1,4,2), Die.new(2,2,6), Die.new(3,2,3)])
    puts "TestG : pass"
  else
    puts "TestG : fail"
  end
  
  '4,2,2,1 : 10 == []'
  shipDefense = 10
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6), Die.new(3,2,3)] 
  yellow = [Die.new(4,1,3)]
  pool = Attack_dice_pool.new(red, orange, yellow, initializeTiers)
  outcome = optimal_die_usage(pool, shipDefense)
  if testPass(outcome, 1, 0, 0, 0, [Die.new(1,4,2), Die.new(2,2,6), Die.new(3,2,3), Die.new(4,1,3)])
    puts "TestH : pass"
  else
    puts "TestH : fail"
  end

  
end

def testPass(outcome, shipD, red, orange, yellow, used_dice)

  if outcome[1] != shipD
    return false
  elsif outcome[0].red.length != red
    return false
  elsif outcome[0].orange.length != orange
    return false
  elsif outcome[0].yellow.length != yellow
    return false
  end
  used_dice.each do |die|
    if !outcome[0].used_dice.delete_if{|e| e.id == die.id}
      return false
    end
  end
  return true
end
'''test()'''
'''
die = Die.new("red")
diea = Die.new("orange")
dieb = Die.new("yellow")
diec = Die.new("red")

p die.id
p diea.id
p dieb.id
p diec.id
'''
def createBattle()
  att_fleet = Fleet.new("att")

  parts = Array.new
  parts.push(Gluon.new)
  parts.push(Gauss.new)
  parts.push(Morph.new)
  parts.push(Tachyon.new)
  parts.push(Ion_turret.new)
  parts.push(Sentient.new)

  ship = Starbase.new(parts, {:computer => 4, :quantity => 2, :side => 'att'})
  att_fleet.add_ship(ship)

  parts.clear()
  parts.push(Electron.new)
  parts.push(Improved.new)
  parts.push(Improved.new)
  parts.push(Nuclear.new)
  parts.push(Flux.new)
  parts.push(Antimatter.new)
  ship = Cruiser.new(parts, {:shield => -1, :quantity => 3, :side => 'att'})
  att_fleet.add_ship(ship)
  
  def_fleet = Fleet.new("def")
  parts.clear()
  parts.push(Positron.new)
  parts.push(Sentient.new)
  parts.push(Conformal.new)
  parts.push(Zero_point.new)
  parts.push(Ion.new)
  parts.push(Ion.new)
  ship = Interceptor.new(parts, {:yellow_cannon => 2, :initiative => 3, :hit_recovery => 1, :side => 'def'})
  def_fleet.add_ship(ship)

  parts.clear()
  parts.push(Parts.new)
  ship = Dreadnought.new(parts, {:yellow_cannon => 2, :initiative => 1, :computer => 1, :side => 'def'})
  def_fleet.add_ship(ship)
  att_fleet.sort_fleet
  def_fleet.sort_fleet

  battle = Battle.new(att_fleet, def_fleet)

end
def shipTest()
  battle = createBattle()
  battle.att_fleet.ships.each do |ship|
    p ship.computer
  end
  battle.def_fleet.ships.each do |ship|
    p ship.computer
  end
end
#shipTest()

def testBattle
  battle = createBattle()

  while !(win = battle.winner?)
    battle.one_round()
  end
  p win.side
end
#testBattle()

def testInitiative()
  battle = createBattle()
  arr = battle.build_initiative_array
  debugger
  arr.each do |ship|
    p ship.initiative
  end

end
#testInitiative()

def createBattle2()
#'fair battle'
  att_fleet = Fleet.new("att")

  parts = Array.new
  parts.push(Gluon.new)
  parts.push(Gauss.new)
  parts.push(Morph.new)
  parts.push(Tachyon.new)
  parts.push(Ion_turret.new)
  parts.push(Sentient.new)

  ship = Starbase.new(parts, {:quantity => 2, :side => 'att'})
  att_fleet.add_ship(ship)

  def_fleet = Fleet.new("def")
  
  parts = Array.new
  parts.push(Gluon.new)
  parts.push(Gauss.new)
  parts.push(Morph.new)
  parts.push(Tachyon.new)
  parts.push(Ion_turret.new)
  parts.push(Sentient.new)

  ship = Starbase.new(parts, {:quantity => 2, :side => 'def'})
  def_fleet.add_ship(ship)

  att_fleet.sort_fleet
  def_fleet.sort_fleet

  battle = Battle.new(att_fleet, def_fleet)

end

def createBattle3()
#'fair battle'
  att_fleet = Fleet.new("att")
  parts = Array.new
  parts.push(Parts.new)
  parts.push(Antimatter.new)
  parts.push(Gluon.new)
  ship = Starbase.new(parts, {:hit_recovery => 2, :side => 'att'})
  att_fleet.add_ship(ship)
  att_fleet.add_passive_abilities('antimatter_split')

  def_fleet = Fleet.new("def")
  
  parts = Array.new
  parts.push(Gluon.new)
  parts.push(Gauss.new)
  parts.push(Ion.new)
  parts.push(Sentient.new)

  ship = Starbase.new(parts, {:quantity => 1, :side => 'def'})
  def_fleet.add_ship(ship)

  att_fleet.sort_fleet
  def_fleet.sort_fleet

  battle = Battle.new(att_fleet, def_fleet)

end

def createBattle4()
#'fair battle'
  att_fleet = Fleet.new("att")
  parts = Array.new
  parts.push(Parts.new)
  parts.push(Antimatter.new)
  parts.push(Gluon.new)
  ship = Starbase.new(parts, {:side => 'att'})
  att_fleet.add_ship(ship)
  att_fleet.add_passive_abilities(['antimatter_split', 'distortion_shield', 'point_defense'])

  def_fleet = Fleet.new("def")
  
  parts = Array.new
  parts.push(Gluon.new)
  parts.push(Gauss.new)
  parts.push(Ion.new)
  parts.push(Sentient.new)

  ship = Starbase.new(parts, {:quantity => 1, :side => 'def'})
  def_fleet.add_ship(ship)

  att_fleet.sort_fleet
  def_fleet.sort_fleet

  battle = Battle.new(att_fleet, def_fleet)

end

def fairBattle()
  results = []
  num_of_battles = 100
  for i in 1..num_of_battles
    battle = createBattle4()
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
  p "Attacking fleet wins #{att_wins} out of #{num_of_battles}"
end
fairBattle()
