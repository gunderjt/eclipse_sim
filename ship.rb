require_relative 'parts.rb'
require 'ruby-debug'

class Ship 
  attr_accessor :computer, :initiative, :shield, :hull, :hit_recovery, :drive, :power, :yellow_missle, :orange_missle, :yellow, :orange, :red, :power_consumption, :note
  def initialize(parts, options = {})
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
  end
  def print_instance_variables
    self.instance_variables.each do |var|
      p " #{self.class.name} #{var}  #{self.instance_variable_get(var)}"
    end
  end
end

class Interceptor < Ship

end

class Dreadnought < Ship

end

class Cruiser < Ship

end

class Starbase < Ship

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
