require_relative 'elevator'

class ElevatorSystem
  attr_reader :elevators, :floors, :requests, :open_elevator

  def initialize(elevators: 3, floors: 10)
    @elevators = elevators.times.map do |i|
      Elevator.new(
        # alternate directions
        direction: (i % 2 == 0 ? :down : :up),
        # split elevators between floors
        floor: (floors - 1) / (i + 1),
        max_floor: floors - 1
      )
    end.cycle

    @floors = floors
    @open_elevator = nil
    @requests = []
  end

  def elevator_request(floor:, direction:)
    @requests << {
      floor: floor,
      direction: direction
    } unless elevator_requested?
  end

  def ready_for_floor_requests?
    !@open_elevator.nil?
  end

  def floor_request(floor)
  end

  def time_passed
    elevators.next do |elevator|
      elevator.move
      elevator.release_passengers
    end
  end

  private

  def elevator_requested?(floor:, direction:)
    @requests.include?({ floor: floor, direction: direction })
  end
end
