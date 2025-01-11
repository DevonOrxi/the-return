extends BattlePhase

class_name MockPhase

var mockTimer = 0

func _init():
	name = "Mock Phase"
	_name = "Mock Phase"

func start(previous_phase_result: PhaseResult = null):
	super.start()
	mockTimer = 0

func _process(delta: float):
	if not _is_timer_up():
		mockTimer += delta
	else:
		change_condition_met.emit(_next_phase, null)

func _is_timer_up() -> bool:
	return mockTimer >= 1
