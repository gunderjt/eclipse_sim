class Fleet
  def initialize
    @ships
    @passive_abilities
  end
  def organize_by_value
    @ships.sort_by(&:value)
  end
  def add_ship(ship)
    @ships.push(ship)
  end
end

class Battle
  def initialize(att_fleet, def_fleet)
    @att_fleet = att_fleet
    @def_fleet = def_fleet
  end
  def initiative_array
    #takes the att_fleet and the def_fleet's ships and returns an array of
    #ships that are organized by inititative, highest first
  end
  def opponent_ship(ship)
    if @att_fleet.ships.include? ship
      return @def_fleet.ships.first()
    else
      return @att_fleet.ships.first()
    end
  end
  
end

'''missle turn'''

'''cannon turns'''

def one_round()
initiative_array.each do |ship|
  die_pool = ship.produce_attack()
  #modify_attack_pool by passive elements
  '''did you attack?'''
  while !die_pool.empty? and (enemy = opponent_ship(ship))
    attack_pool = die_pool.create_attack_clone()
    attack_pool.reduce_by_shield(enemy.shield)
    '''optimaly attack enemy with die'''
    [pool, enemy_defense] = optimal_die_usage(attack_pool, enemy.hull)
    (initiative_array.delete(enemy); defending_array.delete(enemy)) if enemy.destroy_ship?(enemy_defense)
    die_pool.remove_dice(attack_pool.used_dice)
    #check if in frozen state? If die not able to attack remaining shielded ship
  end
end
#heal ships that need to be healed
#check if in frozen state ie, remaining ships have no attack, or not enough
#not enough attack to forgoe healing capabilities, then give victory to defense
