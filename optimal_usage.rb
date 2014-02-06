require 'ruby-debug'
class Die
  attr_accessor :id, :damage, :value
  @@master_id = 0
  '''
  def initialize(color)
    @id = @@master_id = @@master_id + 1
    assign_damage(color)
    roll
  end
'''
  def initialize(id, damage, value)
    @id = id
    @damage = damage
    @value = value
  end  
  def assign_damage(color)
    case color
    when 'red'
      @damage = 4
    when 'orange'
      @damage = 2
    else
      @damage = 1
    end
  end
  def roll
    @value = rand(1..6)
  end
  def add_computer(comp)
    @value += comp
  end
end

class Dice_pool
  attr_accessor :red, :orange, :yellow
  def initialize()
    @red = []
    @orange = []
    @yellow = []
    @current_tier = 2
  end
  def add_die(die)
    case die.damage
    when 4
      @red.push(die).sort_by(&:value).reverse
    when 2
      @orange.push(die).sort_by(&:value).reverse
    else
      @yellow.push(die).sort_by(&:value).reverse
    end
  end
  def remove_dice(used_dice)
    used_dice.each do |die|
      case die.damage
      when 4
        result = @red.delete(die)
      when 2
        result = @orange.delete(die)
      else
        result = @yellow.delete(die)
      end
      if result == nil
        'Error condition: die did not exist'
      end
    end
  end
  def create_attack_clone()
    Attack_dice_pool.new(@red, @orange, @yellow, @current_tier)
  end
end

class Attack_dice_pool < Dice_pool
  attr_accessor :used_dice
  def initialize(red, orange, yellow, current_tier)
    @red = red.sort_by(&:value).reverse
    @orange = orange.sort_by(&:value).reverse
    @yellow = yellow.sort_by(&:value).reverse
    @current_tier = current_tier
    @used_dice = []
  end
  def reduce_by_shield(enemy_shield)
    colors = ['red', 'orange', 'yellow']
    colors.each do |color|
      dice = self.instance_variable_get("@#{color}")
      dice.each do |die|
        dice.delete(die) if (die.value - enemy_shield) < 6
      end
    end
  end
  def view_die
    color_tier = ['yellow', 'orange', 'red']
    while @current_tier >= 0
      '''debugger'''
      tiered_dice = instance_variable_get("@#{color_tier[@current_tier]}")
      return tiered_dice.last if !tiered_dice.empty?
      self.reduce_tier
    end
    return nil
  end
  def damage_remaining
    4*@red.length + 2*@orange.length + @yellow.length
  end
  def number_of_dice
    @red.length + @orange.length + @yellow.length
  end
  def reduce_tier
    @current_tier = @current_tier - 1
  end
  def reset_tier
    @current_tier = 2
  end
end

def optimal_die_usage(attack_dice, ship_hull)
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

  if ship_hull <= 0
    'ship is destroyed, return valid_dice for calculation'
    return [attack_dice, ship_hull]
  else
    'Check to see if there is dice available to attack'
    next_die = attack_dice.view_die
    if next_die == nil
      return [attack_dice, ship_hull]
    elsif next_die.damage <= ship_hull
      ship_hull -= next_die.damage
      attack_dice.remove_dice([next_die])
      attack_dice.used_dice.push(next_die)
      return optimal_die_usage(attack_dice, ship_hull)
    else
      attack_dice_copy = attack_dice.create_attack_clone()
      ship_copy = ship_hull
      
      ship_hull -= next_die.damage
      attack_dice.remove_dice([next_die])
      attack_dice.used_dice.push(next_die)
      outcomeA = optimal_die_usage(attack_dice, ship_hull)
      
      attack_dice_copy.reduce_tier
      outcomeB = optimal_die_usage(attack_dice_copy, ship_copy)
      
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




'''delete'''
class Dice_pool_defunct
  attr_accessor :red, :orange, :yellow, :current_tier
  def initialize(red, orange, yellow, current_tier)
    @red = red.sort_by(&:value).reverse
    @orange = orange.sort_by(&:value).reverse
    @yellow = yellow.sort_by(&:value).reverse
    @current_tier = current_tier
  end
  def clone
    
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

