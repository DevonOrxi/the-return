extends BattlePhase

class_name NPCPlanningBattlePhase

var _next_phase: BattlePhase

func setup(phase_data: Dictionary = {}):
	pass

func set_next_phase(phase: BattlePhase):
	_next_phase = phase
