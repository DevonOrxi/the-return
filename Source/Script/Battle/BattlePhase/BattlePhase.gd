extends Node2D

class_name BattlePhase

var _name: String
var _change_conditions: Array[BattlePhaseChangeCondition]
signal change_condition_met(to_phase: BattlePhase)

func start():
	visible = true
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _init():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta):
	_evaluate_all_conditions()

func _evaluate_all_conditions():
	for i in _change_conditions.size():
		if _change_conditions[i].evaluate():
			_condition_met(_change_conditions[i])
			return

func _condition_met(condition: BattlePhaseChangeCondition):
	var next_phase = condition.get_next_phase()
	change_condition_met.emit(next_phase)

func get_phase_name() -> String:
	return _name
