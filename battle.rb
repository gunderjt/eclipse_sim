require_relative 'optimal_usage.rb'

def frozen_attack?(enemy_ships, die_pool)
  #return true if no dice left can attack the shielded ships
  flag = true
  val_arr = die_pool.value_array
  enemy_ships.each do |ship|
    if ship.shield < 0
      val_arr.each {|die| (flag = false; break;) if die + ship.shield >= 6}
    end
  end
  return flag
end

class Fleet
  attr_accessor :ships, :passive_abilities, :side
  def initialize(side)
    @ships = []
    @passive_abilities = []
    @side = side
  end
  def add_ship(ship)
    @ships.push(ship)
  end
  def add_passive_abilities(passive_abilities)
    @passive_abilities.push(passive_abilities)
  end
  def sort_fleet
    @ships.sort_by(&:value).reverse
  end
end

class Battle
  attr_accessor :att_fleet, :def_fleet
  def initialize(att_fleet, def_fleet)
    @att_fleet = att_fleet
    @def_fleet = def_fleet
    @initiative_array = []
  end
  def build_initiative_array
    #takes the att_fleet and the def_fleet's ships and returns an array of
    #ships that are organized by inititative, highest first
    @initiative_array.clear
    @att_fleet.ships.each do |ship|
      @initiative_array.push(ship)
    end
    @def_fleet.ships.each do |ship|
      @initiative_array.push(ship)
    end
    #debugger
    @initiative_array.sort! do |a, b|
      case 
      when a.initiative > b.initiative
        -1
      when a.initiative < b.initiative
        1
      when a == 'def'
        -1
      else
        1
      end
    end
    #debugger
  end
  def opponent_ships(ship)
    if ship.side == 'att'
      return @def_fleet.ships
    else
      return @att_fleet.ships
    end
  end
  def winner?
    if @att_fleet.ships.empty?
      return @def_fleet
    elsif @def_fleet.ships.empty?
      return @att_fleet
    else
      nil
    end
  end
  def one_round()
    #simulates one_round of battle
    #create initiative array
    build_initiative_array
    @initiative_array.each do |ship|
      die_pool = ship.produce_attack()
      #modify_attack_pool by passive elements
      '''did you attack?'''
      enemy_ships = self.opponent_ships(ship)
      while !die_pool.empty? and (enemy = enemy_ships.first())
        die_pool.clear_die if frozen_attack?(enemy_ships, die_pool)
        '''optimaly attack enemy with die'''
        attack_pool = die_pool.create_attack_clone()
        attack_pool.reduce_by_shield(enemy.shield)
        result = optimal_die_usage(attack_pool, enemy.hull)
        pool = result[0]
        enemy_defense = result[1]
        (@initiative_array.delete(enemy); enemy_ships.delete(enemy)) if enemy.destroy_ship?(enemy_defense)
        die_pool.remove_dice(pool.used_dice)
        #check if in frozen state? If die not able to attack remaining shielded ship
      end
    end
    debugger
    #heal ships that need to be healed
    @initiative_array.each do |ship|
      ship.hull += ship.hit_recovery
      ship.hull = ship.max_hull if ship.hull > ship.max_hull
    end
  end
end

'''missle turn'''

'''cannon turns'''

