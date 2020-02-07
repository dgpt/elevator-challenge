class Elevator
  attr :direction, :passengers, :floor

  def initialize(direction: :up, floor: 1)
    @direction = direction
    @floor = floor
  end
end
