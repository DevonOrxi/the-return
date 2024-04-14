extends BattlePhase

class_name MockPhase

var mockTimer = 0
var next_phase: BattlePhase

func _init():
	name = "Mock Phase"
	_name = "Mock Phase"

func start():
	mockTimer = 0
	super.start()

func _process(delta: float):
	if not _is_timer_up():
		mockTimer += delta
	else:
		change_condition_met.emit(next_phase, {})

func _is_timer_up() -> bool:
	return mockTimer >= 1
