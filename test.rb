require_relative 'parts.rb'
require_relative 'optimal_usage.rb'

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
  if testPass(outcomeA, 0, 1, 0, 0)
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
  if testPass(outcomeB, 0, 0, 2, 0)
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
  if testPass(outcome, 0, 0, 2, 1)
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
  if testPass(outcome, 0, 0, 1, 1)
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
  if testPass(outcome, 0, 0, 1, 0)
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
  if testPass(outcome, 0, 0, 2, 1)
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
  if testPass(outcome, 0, 0, 0, 1)
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
  if testPass(outcome, 1, 0, 0, 0)
    puts "TestH : pass"
  else
    puts "TestH : fail"
  end

  
end

def testPass(outcome, shipD, red, orange, yellow)
  if outcome[1] != shipD
    return false
  elsif outcome[0].red.length != red
    return false
  elsif outcome[0].orange.length != orange
    return false
  elsif outcome[0].yellow.length != yellow
    return false
  end
  return true
end
test()

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
