class_name BattleConfiguration

var phases: Array[BattlePhase] = []

signal instruction_emitted_by_phase(plan: BattleActionSequence)

@warning_ignore("unused_parameter")
func setup(data: Dictionary):
	pass

func exit():
	phases = []
