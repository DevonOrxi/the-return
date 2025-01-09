extends BattlePhase

class_name ExecuteBattlePhase

var _next_phase: BattlePhase

func _init():
	name = "Execute"
	_name = "Execute"

func start(previous_phase_result: PhaseResult = null):
	super.start(previous_phase_result)

func exit():
	super.exit()

# TODO: Refactor, maybe in other level?
func set_next_phase(phase: BattlePhase):
	_next_phase = phase
