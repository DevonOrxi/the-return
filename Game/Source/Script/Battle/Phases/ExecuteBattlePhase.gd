extends BattlePhase

class_name ExecuteBattlePhase

var _next_phase: BattlePhase

func _init():
	name = "Execute"
	_name = "Execute"

func start(with_params: Dictionary = {}):
	super.start(with_params)

func exit():
	super.exit()

# TODO: Refactor, maybe in other level?
func set_next_phase(phase: BattlePhase):
	_next_phase = phase
