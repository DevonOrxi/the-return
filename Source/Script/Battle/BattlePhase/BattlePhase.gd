extends Node2D

class_name BattlePhase

const UIInstructionType = InstructionType.UI

var _name: String
var is_active: bool
signal change_condition_met(to_phase: BattlePhase, action: Dictionary)
signal ui_change(instruction: UIInstructionType, payload: Dictionary)

func start_with_params(_params):
	visible = true
	is_active = true
	process_mode = Node.PROCESS_MODE_PAUSABLE

func start():
	start_with_params(null)

func _ready():
	exit()

func exit():
	visible = false
	is_active = false
	process_mode = Node.PROCESS_MODE_DISABLED

func set_phase_name(new_name: String):
	_name = new_name
	name = new_name

func get_phase_name() -> String:
	return _name
