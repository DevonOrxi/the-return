extends Node2D

class_name BattlePhase

var _name: String
var is_active: bool
signal change_condition_met(to_phase: BattlePhase)

func start_with_params(params):
	visible = true
	is_active = true
	process_mode = Node.PROCESS_MODE_PAUSABLE

func start():
	start_with_params(null)

func _init():
	pass

func _ready():
	exit()

func _process(delta):
	_evaluate_all_conditions(delta)

func _evaluate_all_conditions(delta: float):
	pass

func exit():
	visible = false
	is_active = false
	process_mode = Node.PROCESS_MODE_DISABLED

func set_phase_name(new_name: String):
	_name = new_name
	name = new_name

func get_phase_name() -> String:
	return _name
