extends Node2D

class_name BattlePhase

const UIInstructionType = InstructionType.UI

var _name: String
var _is_active: bool
signal change_condition_met(to_phase: BattlePhase, action: Dictionary)
signal ui_change(instruction: UIInstructionType, payload: Dictionary)

func start():
	visible = true
	_is_active = true
	process_mode = Node.PROCESS_MODE_PAUSABLE

@warning_ignore("unused_parameter")
func setup(phase_data: Dictionary = {}):
	pass

func exit():
	visible = false
	_is_active = false
	process_mode = Node.PROCESS_MODE_DISABLED

func set_phase_name(new_name: String):
	_name = new_name
	name = new_name

func get_phase_name() -> String:
	return _name
