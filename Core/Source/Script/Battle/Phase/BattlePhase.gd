@abstract class_name BattlePhase extends Node2D

const UIOrderType = Enum.UIOrderType

var _name: String
var _is_active: bool
var _previous_phase_result: Dictionary
var _next_phase: BattlePhase

signal change_condition_met(to_phase: BattlePhase, with_result: Dictionary)
signal ui_change(instruction: UIOrderType, payload: Dictionary)

func start(previous_phase_result: Dictionary = {}):
	visible = true
	_is_active = true
	_previous_phase_result = previous_phase_result
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

func set_next_phase(next_phase: BattlePhase):
	_next_phase = next_phase
