require_relative 'elevator_system'

@s = ElevatorSystem.new
@s.elevator_request(direction: :down, floor: 4)
@s.elevator_request(direction: :down, floor: 8)
@s.elevator_request(direction: :up, floor: 3)
@s.elevator_request(direction: :up, floor: 5)
@s.elevator_request(direction: :down, floor: 5)
@s.elevator_request(direction: :up, floor: 7)
