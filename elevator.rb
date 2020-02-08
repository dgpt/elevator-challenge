class Elevator
  attr_reader :passengers, :floor, :max_floor
  attr_accessor :direction

  def initialize(passengers: [], direction: :up, floor: 1, max_floor: nil)
    @passengers = passengers
    @direction = direction
    @floor = floor
    @max_floor = max_floor || floor + 1
  end

  def move(step: 1)
    if (direction == :up)
      @floor += step
    else
      @floor -= step
    end

    # todo: this is weird with step > 1
    if @floor < 0
      reverse_direction
      @floor = 1
    elsif @floor > max_floor
      reverse_direction
      @floor = max_floor - 1
    end

    self
  end

  def reverse_direction
    if @direction == :up
      @direction = :down
    else
      @direction = :up
    end
  end

  def should_release_passengers?
    @passengers.include?(floor)
  end

  def release_passengers
    return false unless should_release_passengers?
    !!@passengers.delete(floor)
  end

  def add_passenger(passenger)
    add_passengers([passenger])
  end

  def add_passengers(passengers)
    @passengers.concat(passengers)
  end
end
