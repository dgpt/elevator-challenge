class Elevator
  attr_reader :direction, :passengers, :floor, :max_floor

  def initialize(direction: :up, floor: 1, max_floor: nil)
    @direction = direction
    @floor = floor
    @max_floors = max_floors || floor + 1
  end

  def move(step: 1)
    if (direction == :up)
      @floor += step
    else
      @floor -= step
    end

    if @floor < 0
      @floor = 0
    elsif @floor > max_floor
      @floor = max_floor
    end
  end

  def should_release_passengers?
    @passengers.include?(floor)
  end

  def release_passenger(passenger)
    return unless should_release_passengers?
    @passengers.delete(passenger)
  end

  def add_passenger(passenger)
    @passengers.push(passenger)
  end
end
