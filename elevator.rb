class Elevator
  attr_reader :direction, :passengers, :floor, :max_floor

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

    if @floor < 0
      @direction = :up
      @floor = 1
    elsif @floor > max_floor
      @direction = :down
      @floor = max_floor - 1
    end

    self
  end

  def should_release_passengers?
    @passengers.include?(floor)
  end

  def release_passengers
    return false unless should_release_passengers?
    success = !!@passengers.delete(floor)
    puts "Passenger(s) dropped off on floor #{floor + 1}" if success
    success
  end

  def add_passenger(passenger)
    add_passengers([passenger])
  end

  def add_passengers(passengers)
    @passengers.concat(passenger)
    puts "Passenger(s) picked up from floor #{floor + 1}"
  end
end
