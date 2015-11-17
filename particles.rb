require 'rubygame'

class Particles
  GRAVITY = [0, -0.1]
  NUMBER_OF_PARTICLES = 5
  D_X = [-1, 1]
  D_Y = [-2, 0]
  RESOLUTION = [800,640]

  def initialize
    @screen = Rubygame::Screen.new RESOLUTION, 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    @particles = []
    @origin = [50, 50]
  end

  def run
    loop do
      update
      spawn
      advance(@clock.tick)
      die
      draw
    end
  end

  def spawn
    NUMBER_OF_PARTICLES.times do
      d_x = rand_between(*D_X)
      d_y = rand_between(*D_Y)
      @particles << Particle.new(*@origin, d_x, d_y, 500)
    end
  end

  def die
    @particles = @particles.select { |particle| !particle.dead? }
  end

  def advance(time)
    @particles.each do |particle|
      particle.advance(time)
      particle.add_velocity(*GRAVITY)
    end
  end

  def update
    @queue.each do |ev|
      case ev
      when Rubygame::MouseMotionEvent
        @origin = ev.pos
      when Rubygame::QuitEvent
        Rubygame.quit
        exit
      end
    end
  end

  def draw
    @screen.fill([0x00, 0x00, 0x00])
    @particles.each { |particle| particle.draw(@screen) }
    @screen.update
  end

  private

  def rand_between(min, max)
    rand * (max - min) + min
  end
end

class Particle
  attr_reader :x, :y

  def initialize(x, y, d_x, d_y, time_to_live)
    @x = x
    @y = y
    @d_x = d_x
    @d_y = d_y
    @time_to_live = time_to_live
  end

  def advance(time_elapsed)
    @x += @d_x
    @y += @d_y
    @time_to_live -= time_elapsed
  end

  def add_velocity(add_vel_x, add_vel_y)
    @d_x += add_vel_x
    @d_y += add_vel_y
  end

  def draw(screen)
    screen.draw_circle_s([@x, @y], 2, [0xff, 0x00, 0x00])
  end

  def dead?
    @time_to_live <= 0
  end
end

Particles.new.run
