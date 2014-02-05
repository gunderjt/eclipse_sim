class Parts
 attr_accessor :computer, :initiative, :shield, :hull, :hit_recovery, :drive, :power, :yellow_missle, :orange_missle, :yellow, :orange, :red, :power_consumption, :note
  def initialize()
    '''Computer'''
    @computer ||=0
    @initiative ||=0
    '''Shield/hull'''
    @shield  ||=0
    @hull ||=0
    @hit_recovery ||=0
    '''drive'''
    @drive ||=0
    '''power'''
    @power ||=0
    '''missles'''
    @yellow_missle ||=0
    @orange_missle ||=0
    '''Cannon'''
    @yellow_cannon ||=0
    @orange_cannon ||=0
    @red_cannon ||=0
    '''misc'''
    @power_consumption ||=0
    @note ||=nil
  end
end

'''Computers'''
class Gluon < Parts
  def initialize()
    @computer = 3
    @power_consumption = 2
    @initiative = 2
    super
  end
end

class Positron < Parts
  def initialize()
    @computer = 2
    @power_consumption = 1
    @initiative = 1
    super
  end
end

class Electron < Parts
  def initialize()
    @computer = 1
    super
  end
end

class Axion < Parts
  def initialize()
    @computer = 3
    super
  end
end

'''Shields'''
class Phase < Parts
  def initialize()
    @shield = -2
    @power_consumption = 1
    super
  end
end

class Gauss < Parts
  def initialize()
    @shield = -1
    super
  end
end

class Morph < Parts
  def initialize()
    @shield = -1
    @hit_recovery = 1
    @initiative = 2
    super
  end
end

class Flux < Parts
  def initialize()
    @shield = -3
    @power_consumption = 2
    super
  end
end

'''Hulls'''
class Hull < Parts
  def initialize()
    @hull = 1
    super
  end
end

class Improved < Parts
  def initialize()
    @hull = 2
    super
  end
end

class Sentient < Parts
  def initialize()
    @hull = 1
    @computer = 1
    super
  end
end

class Shard < Parts
  def initialize()
    @hull = 3
    super
  end
end

class Interceptor_Bay < Parts
  def initialize()
    @hull = 1
    @power_consumption = 2
    @note = "Can carry two interceptors"
    super
  end
end

class Conifold < Parts
  def initialize()
    @hull = 3
    @power_consumption = 2
    super
  end
end

'''Drives'''
class Nuclear < Parts
  def initialize()
    @drive = 1
    @power_consumption = 1
    @initiative = 1
    super
  end
end

class Fusion < Parts
  def initialize()
    @drive = 2
    @power_consumption = 2
    @initiative = 2
    super
  end
end

class Tachyon < Parts
  def initialize()
    @drive = 3
    @power_consumption = 3
    @initiative = 3
    super
  end
end

class Conformal < Parts
  def initialize()
    @drive = 4
    @power_consumption = 2
    @initiative = 2
    super
  end
end

class Jump < Parts
  def initialize()
    @drive = 1
    @power_consumption = 2
    super
  end
end

'''Power Sources'''
class Nuclear_source < Parts
  def initialize()
    @power = 3
    super
  end
end

class Fusion_source < Parts
  def initialize()
    @power = 6
    super
  end
end

class Tachyon_source < Parts
  def initialize()
    @power = 9
    super
  end
end

class Zero_point < Parts
  def initialize()
    @power = 12
    super
  end
end

class Hypergrid < Parts
  def initialize()
    @power = 11
    super
  end
end

class Muon < Parts
  def initialize()
    @power = 2
    @initiative = 1
    super
  end
end

'''Missles'''
class Plasma_missle < Parts
  def initialize()
    @orange_missle = 2
    super
  end
end

class Flux < Parts
  def initialize()
    @yellow_missle = 2
    @initiative = 3
    super
  end
end

'''Cannon'''
class Ion < Parts
  def initialize()
    @yellow_cannon = 1
    @power_consumption = 1
    super
  end
end

class Plasma < Parts
  def initialize()
    @orange_cannon = 1
    @power_consumption = 2
    super
  end
end

class Antimatter < Parts
  def initialize()
    @red_cannon = 1
    @power_consumption = 4
    super
  end
end

class Ion_turret < Parts
  def initialize()
    @yellow_cannon = 2
    @power_consumption = 1
    super
  end
end

class Ion_disruptor < Parts
  def initialize()
    @yellow_cannon = 1
    @initiative = 3
    super
  end
end

