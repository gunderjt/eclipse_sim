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
    @passive_abilities = passive_abilities
  end
  def sort_fleet
    @ships.sort_by(&:value).reverse
  end
  def distortion_shield?
    @passive_abilities.include?('distortion_shield')
  end
  def antimatter_split?
    @passive_abilities.include?('antimatter_split')
  end
  def point_defense?
    @passive_abilities.include?('point_defense')
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
      when a.side == 'def'
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
    if (winner = frozen_battle?)
      return winner
    end
    if @att_fleet.ships.empty?
      return @def_fleet
    elsif @def_fleet.ships.empty?
      return @att_fleet
    else
      nil
    end
  end
  def missle_round
    dist_shield = -2
    att_pool = Dice_pool.new
    def_pool = Dice_pool.new
    @att_fleet.ships.each do |ship|
      if ship.missles?
        temp_pool = ship.produce_attack('missle')
        att_pool.pool_dice(temp_pool)
      end
    end
    @def_fleet.ships.each do |ship|
      if ship.missles?
        temp_pool = ship.produce_attack('missle')
        def_pool.pool_dice(temp_pool)
      end
    end
    #ATTACK!!!
    enemy = @def_fleet.ships.first()
    att_pool.reduce_by_shield(dist_shield) if @def_fleet.distortion_shield?
    point_defense(att_pool,@def_fleet.ships) if @def_fleet.point_defense?
    while !att_pool.empty? and (enemy = @def_fleet.ships.first())
      attack_pool = die_pool.create_attack_clone()
      result = optimal_die_usage(attack_pool, enemy.hull)
      pool = result[0]
      enemy_defense = result[1]
      (@def_fleet.delete(enemy)) if enemy.destroy_ship?(enemy_defense)
      die_pool.remove_dice(pool.used_dice)
    end
    enemy = @att_fleet.ships.first()
    def_pool.reduce_by_shield(dist_shield) if @att_fleet.distortion_shield?
    point_defense(att_pool,@att_fleet.ships) if @att_fleet.point_defense?
    while !def_pool.empty? and (enemy = @att_fleet.ships.first())
      attack_pool = die_pool.create_attack_clone()
      result = optimal_die_usage(attack_pool, enemy.hull)
      pool = result[0]
      enemy_defense = result[1]
      (@att_fleet.delete(enemy)) if enemy.destroy_ship?(enemy_defense)
      die_pool.remove_dice(pool.used_dice)
    end
  end

  def missle_round_defunct
    dist_shield_bonus = -2
    build_initiative_array
    @initiative_array.delete_if {|e| !e.missle?}
    @initiative_array.each do |ship|
      die_pool = ship.produce_attack('missle')
      enemy_ships = self.opponent_ships(ship)
      while !die_pool.empty? and (enemy = enemy_ships.first())
        die_pool.reduce_reduce_by_shield(dist_shield_bonus) if passive_ability?(enemy, "distortion_shield?")
        result = optimal_die_usage(attack_pool, enemy.hull)
        pool = result[0]
        enemy_defense = result[1]
        (@initiative_array.delete(enemy); enemy_ships.delete(enemy)) if enemy.destroy_ship?(enemy_defense)
        die_pool.remove_dice(pool.used_dice)
      end
    end
  end
  def point_defense(attack_pool, defending_fleet)
    defend_pool = Dice_pool.new
    defending_fleet.each do |ship|
      temp_pool = ship.produce_attack
      temp_pool.split_antimatter if passive_ability?(ship, "antimatter_split?")
      defend_pool.pool_dice(temp_pool)
    end
    attack_pool.remove_die_by_num(defend_pool.number_of_dice)
  end
  def passive_ability?(ship, ability)
    if @att_fleet.side == ship.side
      return @att_fleet.send(ability) if @att_fleet.respond_to? ability
    else
      return @def_fleet.send(ability) if @def_fleet.respond_to? ability
    end
    return false
  end
  def one_round()
    #simulates one_round of battle
    #create initiative array
    build_initiative_array
    @initiative_array.each do |ship|
      die_pool = ship.produce_attack() 
      #modify_attack_pool by passive elements
      die_pool.split_antimatter if passive_ability?(ship, "antimatter_split?")
      '''did you attack?'''
      enemy_ships = self.opponent_ships(ship)
      while !die_pool.empty? and (enemy = enemy_ships.first())
        #die_pool.clear_die if frozen_attack?(enemy_ships, die_pool)
        break if frozen_attack?(enemy_ships, die_pool)
        '''optimaly attack enemy with die'''
        attack_pool = die_pool.create_attack_clone()
        attack_pool.reduce_by_shield(enemy.shield)
        result = optimal_die_usage(attack_pool, enemy.hull)
        pool = result[0]
        enemy_defense = result[1]
        (@initiative_array.delete(enemy); enemy_ships.delete(enemy)) if enemy.destroy_ship?(enemy_defense)
        die_pool.remove_dice(pool.used_dice)
      end
    end
    #heal ships that need to be healed
    @initiative_array.each do |ship|
      ship.hull += ship.hit_recovery
      ship.hull = ship.max_hull if ship.hull > ship.max_hull
    end
  end
  def frozen_battle?
    #battle is frozen if a) noone has cannons (def wins) or
    #b) the added power of one sides weapons is <= the hit recovery of any ship
    #on the enemy team.  in which case that side wins (check defense first).

    att_add = def_add = 0
    @att_fleet.ships.each do |ship|
      att_add += ship.cannons_damage
    end
    @def_fleet.ships.each do |ship|
      def_add += ship.cannons_damage
    end
    return att_add > 0 ? @att_fleet : @def_fleet unless (att_add > 0 and def_add > 0)
    
    @def_fleet.ships.each do |ship|
      return @def_fleet if ship.hit_recovery >= att_add
    end
    @att_fleet.ships.each do |ship|
      return @att_fleet if ship.hit_recovery >= def_add
    end
    return nil
  end
end

'''missle turn'''

'''cannon turns'''

