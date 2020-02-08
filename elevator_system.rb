require_relative 'elevator'

class ElevatorSystem
  attr_reader :elevators, :elevator_cycle, :floors, :requests, :open_elevator

  def initialize(elevators: 3, floors: 10)
    @elevators = elevators.times.map do |i|
      Elevator.new(
        # alternate directions
        direction: :up,
        # split elevators between floors
        floor: ((floors - 1) / elevators) * i + 1,
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
    } unless @requests.include?({ floor: floor, direction: direction })
  end

  def ready_for_floor_requests?
    !open_elevator.nil?
  end

  def floor_request(requested_floors)
    requested_floors = requested_floors.is_a?(Enumerable) ? requested_floors : [requested_floors]

    unless ready_for_floor_requests?
      puts "Please wait for passengers to be picked up before requesting a floor"
      return false
    end

    requested_floors.each do |floor|
      if floor > floors - 1
        puts "Please pick a floor between 0 and #{floors - 1}"
        return false
      end
    end

    open_elevator.add_passengers(requested_floors)
    open_elevator
  end

  def time_passed
    unless @open_elevator.nil?
      puts "The elevator closes its doors and heads to floor(s) #{@open_elevator.passengers.join(', ')}"
    end
    @open_elevator = nil

    to_move = elevators.select { |e| e.passengers.length > 0 }
    to_move += @requests.map do |request|
      nearest_elevator(floor: request[:floor], direction: request[:direction])
    end

    Set.new(to_move).map { |e|
      next if @open_elevator
      move_elevator(e)
    }.compact
  end

  private

  def move_elevator(elevator)
    elevator.move
    dropped_off = elevator.release_passengers
    puts "Passenger(s) dropped off on floor #{elevator.floor}" if dropped_off

    if elevator_requested?(elevator)
      @requests.delete({ floor: elevator.floor, direction: elevator.direction })
      puts "Passenger(s) picked up from floor #{elevator.floor}. Awaiting floor requests..."
      @open_elevator = elevator
    end

    elevator
  end

  def elevator_requested?(elevator)
    if elevator.passengers.length > 0
      @requests.include?({ floor: elevator.floor, direction: elevator.direction })
    else
      request = @requests.find { |r| r[:floor] == elevator.floor}
      if request
        # hacky side effects here >_> <_<
        elevator.direction = request[:direction]
        true
      else
        false
      end
    end
  end

  def nearest_elevator(floor:, direction:)
    heading_opposite = proc do |elev|
      elev.direction == :down && elev.floor < floor ||
        elev.direction == :up && elev.floor > floor
    end

    @elevators.sort do |a, b|
      a_heading_opposite = heading_opposite.call(a)
      b_heading_opposite = heading_opposite.call(b)
      if (a_heading_opposite && b_heading_opposite)
        0
      elsif (a_heading_opposite || b_heading_opposite)
        a_heading_opposite ? 1 : -1;
      elsif (a.direction != b.direction)
          a.direction == direction ? -1 : 1;
      else
        (a.floor - floor).abs <=> (b.floor - floor).abs
      end
    end.first
  end
end
