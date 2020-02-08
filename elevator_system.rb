require_relative 'elevator'

class ElevatorSystem
  attr_reader :elevators, :elevator_cycle, :floors, :requests, :open_elevator

  def initialize(elevators: 3, floors: 10)
    @elevators = elevators.times.map do |i|
      Elevator.new(
        # alternate directions
        direction: (i % 2 == 0 ? :down : :up),
        # split elevators between floors
        floor: (floors - 1) / (i + 1),
        max_floor: floors - 1
      )
    end

    @elevator_cycle = @elevators.cycle
    @floors = floors
    @open_elevator = nil
    @requests = []
  end

  def elevator_request(floor:, direction:)
    @requests << {
      floor: floor,
      direction: direction
    } unless elevator_requested?(floor: floor, direction: direction)
  end

  def ready_for_floor_requests?
    !open_elevator.nil?
  end

  def floor_request(floor)
    unless ready_for_floor_requests?
      puts "Please wait for passengers to be picked up before requesting a floor"
      return false
    end

    open_elevator.add_passenger(floor)
  end

  def time_passed
    move_elevator elevator_cycle.next
  end

  private

  def move_elevator(elevator)
    elevator.move
    dropped_off = elevator.release_passengers
    puts "Passenger(s) dropped off on floor #{elevator.floor}" if dropped_off

    if elevator_requested?(floor: elevator.floor, direction: elevator.direction)
      @requests.delete({ floor: elevator.floor, direction: elevator.direction })
      puts "Passenger(s) picked up from floor #{elevator.floor}. Awaiting floor requests..."
      @open_elevator = elevator
    end

    elevator
  end

  def elevator_requested?(floor:, direction:)
    @requests.include?({ floor: floor, direction: direction })
  end

  def nearest_elevator(floor:, direction:)
    @elevators.sort do |a, b|
      if (a.direction != b.direction)
        a.direction == direction ? -1 : 1;
      else
        (a.floor - floor).abs <=> (b.floor - floor).abs
      end
    end
  end
end
