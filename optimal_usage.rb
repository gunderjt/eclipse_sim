class Die
  attr_accessor :id, :damage, :value
  def initialize(id, damage, value)
    @id = id
    @damage = damage
    @value = value
  end
end

class Dice_pool
  attr_accessor :red, :orange, :yellow, :current_tier
  def initialize(red, orange, yellow, current_tier)
    @red = red.sort_by(&:value).reverse
    @orange = orange.sort_by(&:value).reverse
    @yellow = yellow.sort_by(&:value).reverse
    @current_tier = current_tier
  end
  def clone
    Dice_pool.new(@red, @orange, @yellow, @current_tier)
  end
  def view_die
    if @current_tier == 3 
      if !@red.empty?
        @red.last
      else
        self.reduce_tier
        return self.view_die
      end
    elsif @current_tier == 2 
      if !@orange.empty?
        @orange.last
      else
        self.reduce_tier
        self.view_die
      end
    elsif @current_tier == 1 
      if !@yellow.empty?
        @yellow.last
      else
        self.reduce_tier
        return nil
      end
    end
  end
  def return_die
    if @current_tier == 3 
      if !@red.empty?
        @red.pop
      else
        self.reduce_tier
        return self.return_die
      end
    elsif @current_tier == 2 
      if !@orange.empty?
        @orange.pop
      else
        self.reduce_tier
        self.return_die
      end
    elsif @current_tier == 1 
      if !@yellow.empty?
        @yellow.pop
      else
        self.reduce_tier
        return nil
      end
    end
  end
  def damage_remaining
    4*@red.length + 2*@orange.length + @yellow.length
  end
  def number_of_dice
    @red.length + @orange.length + @yellow.length
  end
  def reduce_tier
    @current_tier = @current_tier - 1
    self
  end
  def reset_tier
    @current_tier = 3
  end
  def print_remaining_die
    @red.each do |die|
      print "red " + die.id + " " + die.value 
    end
    @orange.each do |die|
      print "orange " + die.id + " " + die.value 
    end
    @yellow.each do |die|
      print "yellow " + die.id + " " + die.value 
    end
  end
end

def optimal_die_usage(valid_dice, ship)
=begin
Optimal_usage is the algorithm that decides the best way to allocate dice so
that by the end you have reduced the ships health to zero.  It returns, the IDs
of the dice that were used so that one can eliminate them from the remaining
dice total

The optimal choice is the outcome whose remaining dice have the greatest
remaining attack, and in the event of a tie, the outcome who has the greatest
remaining die count.

SOME REFACTORING:
Try to find a way to store the reference to a dice to view it, and then 
remove it if it is what we want.
  /*Organize the dice by their attack value */
  /*valid_remaining_dice.sort_by(&:damage).reverse*/
=end

  if ship <= 0
    'ship is destoryed, return valid_dice for calculation'
    return [valid_dice, ship]
  else
    'Check to see if there is dice available to attack'
    next_die = valid_dice.view_die

    if next_die == nil
      return [valid_dice, ship]
    elsif next_die.damage <= ship
      ship = ship - valid_dice.return_die.damage
      return optimal_die_usage(valid_dice, ship)
    else
      pool_copy = valid_dice.clone
      ship_copy = ship
      
      ship = ship - valid_dice.return_die.damage
      outcomeA = optimal_die_usage(valid_dice.clone, ship)
      
      pool_copy.reduce_tier
      outcomeB = optimal_die_usage(pool_copy, ship_copy)
      
      return compare_outcomes(outcomeA, outcomeB)
    end
  end
end



def compare_outcomes(outcome_A, outcome_B)
  '''if both scenarios produced a destroyed ship...choose the one who did it with fewest resources'''

  if outcome_A[1] <=0 && outcome_B[1] <=0
    if outcome_A[0].damage_remaining > outcome_B[0].damage_remaining
      return outcome_A
    elsif outcome_B[0].damage_remaining > outcome_A[0].damage_remaining
      return outcome_B
    else
      if outcome_B[0].number_of_dice > outcome_A[0].number_of_dice
        return outcome_B
      else
        return outcome_A
      end
    end
    '''if neither/only one produced a destroyed ship, return the weakest ship.'''
  elsif outcome_B[1] < outcome_A[1]
    return outcome_B
  else
    return outcome_A
  end
end

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
  initializeTiers = 3
  'TestA: [4,2,1] : 3 == 2,1'
  red = [Die.new(1,4,2)]
  orange = [Die.new(2,2,6)] 
  yellow = [Die.new(3,1,3)]
  poolA = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  poolB = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  pool = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  pool = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  pool = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  pool = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  pool = Dice_pool.new(red, orange, yellow, initializeTiers)
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
  pool = Dice_pool.new(red, orange, yellow, initializeTiers)
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
