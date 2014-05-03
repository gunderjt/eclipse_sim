require_relative 'parts.rb'
require_relative 'optimal_usage.rb'
require 'ruby-debug'

class Ship
  attr_accessor :computer, :initiative, :shield, :hull, :hit_recovery, :drive, :power, :red_missle, :yellow_missle, :orange_missle, :yellow_cannon, :orange_cannon, :red_cannon, :power_consumption, :note, :quantity, :id, :side, :value, :max_hull
  @@master_id = 0
  def initialize(parts, options = {})
    @id = @@master_id = @@master_id + 1
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
    parts.each do |part|
      part.instance_variables.each do |var|
        unless var == :@note
          unless self.instance_variable_defined?(var)
            self.instance_variable_set(var, 0)
          end
          value = self.instance_variable_get(var)
          self.instance_variable_set(var, value + part.instance_variable_get(var))
        end
      end
    end
    racial_abilities(options[:race])
    @quantity = options[:quantity] || 1
    @max_hull = @hull += 1
    @value = self.produce_value
  end

  def destroy_ship?(damage)
    @hull = damage
    if @hull <= 0
      @quantity -= 1 
      @hull = @max_hull
    end
    @quantity <= 0
  end
  def missles?
    (@red_missle.length + @yellow_missle.length + @orange_missle.length) > 0
  end
  def cannons_damage
    @yellow_cannon + @orange_cannon*2 + @red_cannon*4
  end
  def produce_attack(type = 'cannon')
    attack = ['red','orange','yellow']

    die_pool = Dice_pool.new
    attack.each do |color|
      if i = self.instance_variable_get("@#{color}_#{type}")
        i*=@quantity
        while i > 0
          new_die = Die.new(options = {:color => color})
          new_die.add_computer(@computer)
          if(new_die.value >= 6)
            die_pool.add_die(new_die)
          end
          i-=1
        end
      end
    end
    return die_pool
  end
  def produce_value
    #smallest hull, greater computer, greater attack_power, shield
    value = ((@yellow_cannon + @red_cannon*4 + @orange_cannon*2) +
             (@computer*2 - @shield) + @initiative)
    value / @hull.to_f
  end
  def print_instance_variables
    self.instance_variables.each do |var|
      p "#{self.class.name} #{var}  #{self.instance_variable_get(var)}"
    end
  end
  def racial_abilities(race = 'terran')
    case race
    when 'eridani'
      if self.class.name == 'Dreadnought'
        @power += 1
      end
    when 'exiles'
      if self.class.name == 'Starbase'
        @initiative -= 4
        @hull += 1
        @power += 1
      end
    when 'planta'
      @intitiave += -2
      @computer += 1
      @power += 1
    when 'rho_indi'
      @shield += -1
      @initiative += 1 unless self.class.name == 'Starbase'
    when 'orion'
      @initiative +=1
      case self.class.name
      when 'Interceptor'
        @power += 1
      when 'Cruiser'
        @power += 2
      when 'Dreadnought'
        @power += 3
      end
    else
    end
  end
end

class Interceptor < Ship
  def initialize(parts, options = {})
    super
    @initiative += 2
  end
end
class Cruiser < Ship
  def initialize(parts, options = {})
    super
    @initiative += 1
  end
end
class Dreadnought < Ship
  def initialize(parts, options = {})
    super
  end
end
class Starbase < Ship
  def initialize(parts, options = {})
    super
    @initiative += 4
  end
end

def create_ship(json, side, ship_type)
  attributes = ["computer", "initiative", "shield", "hull", "hit_recovery", "drive", "power", "red_missle", "yellow_missle", "orange_missle", "yellow_cannon", "orange_cannon", "red_cannon", "power_consumption", "note", "quantity"]
  h = Hash.new()
  attributes.each do |item|
    h[item.to_sym] = json[side][ship_type][item]
  end
  h[:side] = side
  Ship.new([], h)
end

