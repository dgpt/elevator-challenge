require_relative 'elevator'

class ElevatorSystem
  attr_reader :elevators, :floors

  def initialize(elevators: 3, floors: 10)
    @elevators = elevators.times.map do |i|
      Elevator.new(
        # alternate directions
        direction: (i % 2 == 0 ? :down : :up),
        # split elevators between floors
        floor: floors / (i + 1)
      )
    end

    @floors = floors
  end

  def elevator_request(floor:, direction:)
  end

  def floor_request(floor)
  end

  def time_passed
  end
end
