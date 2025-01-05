extends BattlePhase

class_name MockPhase

var mockTimer = 0
var next_phase: BattlePhase
var payload: Dictionary

func _init():
	name = "Mock Phase"
	_name = "Mock Phase"
	
func setup(phase_data: Dictionary = {}):
	payload = phase_data

func start(with_params: Dictionary = {}):
	super.start(with_params)
	mockTimer = 0

func _process(delta: float):
	if not _is_timer_up():
		mockTimer += delta
	else:
		change_condition_met.emit(next_phase, payload)

func _is_timer_up() -> bool:
	return mockTimer >= 1
