require_relative 'parts.rb'
require_relative 'optimal_usage.rb'
require 'ruby-debug'

class Ship
  attr_accessor :computer, :initiative, :shield, :hull, :hit_recovery, :drive, :power, :yellow_missle, :orange_missle, :yellow_cannon, :orange_cannon, :red_cannon, :power_consumption, :note, :quantity, :id, :side
  @master_id = 0
  def initialize(parts, options = {})
    @id = @master_id = @master_id + 1
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
    @max_hull = @hull
    @value = self.produce_value
    @quantity = options{:quantity} || 1
  end

  def destroy_ship?(damage)
    @hull -= damage
    if @hull <= 0
      @quantity -= 1 
      @hull = @max_hull
    end
    @quantity <= 0
  end
  def missle?
    (@yellow_missle + @orange_missle) > 0
  end
  def produce_attack(type = 'cannon')
    attack = ['red','orange','yellow']
    die_pool = Die_pool.new()
    attack.each do |color|
      if i = self.instance_variable_get("@#{color}_#{type}")
        i*=@quanitity
        while i > 0
          new_die = Die.new(color)
          new_die.add_computer(@computer) unless new_die.value == 1
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
  end
  def print_instance_variables
    self.instance_variables.each do |var|
      p " #{self.class.name} #{var}  #{self.instance_variable_get(var)}"
    end
  end
end

parts = Array.new
parts.push(Gluon.new)
parts.push(Gauss.new)
parts.push(Morph.new)
parts.push(Tachyon.new)
parts.push(Ion_turret.new)
parts.push(Sentient.new)

ship = Ship.new(parts, {:computer => 4})
#ship.print_instance_variables
p ship.computer
