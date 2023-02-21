require 'gosu'

class SnakeGame < Gosu::Window
  GRID_SIZE = 20
  GRID_WIDTH = 600 / GRID_SIZE
  GRID_HEIGHT = 600 / GRID_SIZE

  def initialize
    super 600, 600
    self.caption = "Snake Game"
    @snake = Snake.new
    @fruit = Fruit.new
  end

  def update
    @snake.move
    if @snake.ate_fruit?(@fruit.x, @fruit.y)
      @fruit.respawn
      @snake.grow
    end
     sleep 0.1
  end

  def draw
    @snake.draw
    @fruit.draw
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @snake.turn_left if id == Gosu::KbLeft
    @snake.turn_right if id == Gosu::KbRight
  end
end

class Snake
  def initialize
    @x = SnakeGame::GRID_WIDTH / 2 * SnakeGame::GRID_SIZE
    @y = SnakeGame::GRID_HEIGHT / 2 * SnakeGame::GRID_SIZE
    @direction = :right
    @snake_segments = [[@x, @y]]
  end

  def move
    case @direction
    when :right
      @x += SnakeGame::GRID_SIZE
      @x = 0 if @x >= SnakeGame::GRID_WIDTH * SnakeGame::GRID_SIZE
    when :left
      @x -= SnakeGame::GRID_SIZE
      @x = (SnakeGame::GRID_WIDTH - 1) * SnakeGame::GRID_SIZE if @x < 0
    when :up
      @y -= SnakeGame::GRID_SIZE
      @y = (SnakeGame::GRID_HEIGHT - 1) * SnakeGame::GRID_SIZE if @y < 0
    when :down
      @y += SnakeGame::GRID_SIZE
      @y = 0 if @y >= SnakeGame::GRID_HEIGHT * SnakeGame::GRID_SIZE
    end
    @snake_segments.unshift([@x, @y])
    @snake_segments.pop unless @growing
    @growing = false
  end

  def ate_fruit?(fruit_x, fruit_y)
    @x == fruit_x && @y == fruit_y
  end

  def grow
    @growing = true
  end

  def turn_left
    case @direction
    when :right
      @direction = :up
    when :left
      @direction = :down
    when :up
      @direction = :left
    when :down
      @direction = :right
    end
  end

  def turn_right
    case @direction
    when :right
      @direction = :down
    when :left
      @direction = :up
    when :up
      @direction = :right
    when :down
      @direction = :left
    end
  end

  def draw
    @snake_segments.each do |segment|
      Gosu.draw_rect(segment[0], segment[1],   SnakeGame::GRID_SIZE, SnakeGame::GRID_SIZE, Gosu::Color::GREEN)
    end
  end
end

class Fruit
  def initialize
    respawn
  end
  def x
    @x
  end
  def y
    @y
  end
  
  def draw
    Gosu.draw_rect(@x, @y, SnakeGame::GRID_SIZE, SnakeGame::GRID_SIZE, Gosu::Color::RED)
  end
  
  def respawn
    @x = rand(SnakeGame::GRID_WIDTH) * SnakeGame::GRID_SIZE
    @y = rand(SnakeGame::GRID_HEIGHT) * SnakeGame::GRID_SIZE
  end
end

SnakeGame.new.show
