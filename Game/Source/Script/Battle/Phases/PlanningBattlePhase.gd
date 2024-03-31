extends BattlePhase

class_name PlanningBattlePhase

class NavigationMap:
	var looping: bool
	var grid: Dictionary
	var dimensions: Vector2
	var pointer: Vector2
	
	func move_pointer_by(movement: Vector2):
		var result = pointer + movement
		
		if result.x >= dimensions.x:
			if looping:
				result.x %= dimensions.x
			else:
				result.x = dimensions.x - 1
		
		if result.y >= dimensions.y:
			if looping:
				result.y %= dimensions.y
			else:
				result.y = dimensions.y - 1

class PlanningStep:
	var navigation_map: NavigationMap
	var partial_result: Dictionary

class BattleInfo:
	var actor: Battler

var _next_phase: BattlePhase
var _actor: Battler
var _battle_info: BattleInfo
var _action_result: Dictionary
var _current_navigation_map: NavigationMap

func _init():
	name = "Planning"
	_name = "Planning"

func setup(phase_data: Dictionary = {}):
	_battle_info = BattleInfo.new()
	
	var actor = phase_data["actor"] as Battler
	if not actor:
		push_error("ERROR: No actor for Planning Phase!")
	
	_battle_info.actor = actor

func start():
	super.start()
	
	# TODO: Refactor, make generic
	var commands = _battle_info.actor.get_commands()
	var command_names = commands.map(func(cmd): return cmd.get_name())
	var change_payload = {}
	change_payload["enable_panel_target"] = "BaseAction"
	change_payload["is_focus"] = true
	change_payload["panel_elements"] = command_names
	
	var cursor_payload = {}
	cursor_payload["cursor_element_indices"] = [0]
	
	ui_change.emit(UIInstructionType.DISABLE_ALL_ACTION_PANELS, {})
	ui_change.emit(UIInstructionType.ENABLE_PANEL, change_payload)
	ui_change.emit(UIInstructionType.SHOW_SELECTION_CURSORS_UI_ELEMENT, cursor_payload)

func _process(_delta):
	_check_player_input()
	

func _check_player_input():
	#
	#
	# Placeholder
	if Input.is_action_just_pressed("ui_accept"):
		change_condition_met.emit(_next_phase, {})

func exit():
	super.exit()
	
	_actor = null
	_battle_info = null

func set_next_phase(phase: BattlePhase):
	_next_phase = phase
