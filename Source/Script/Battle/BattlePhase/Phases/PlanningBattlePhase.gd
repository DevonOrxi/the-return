extends BattlePhase

class_name PlanningBattlePhase

enum ActionType {
	SELECT_ACTOR,
	SELECT_BASE_ACTION,
	SELECT_ABILITY,
	ABILITY_SPECIFICS,
	TARGET_ENEMY_ALL,
	TARGET_ENEMY_SINGLE,
	TARGET_SELF,
	TARGET_ALLY_SINGLE,
	TARGET_ALLY_ALL,
	TARGET_ANY,
	EXECUTE
}

class Action:
	var _stack: Array[ActionType]
	var _stack_pointer = 0
	var name: String
	var args: Array

class ActionResult:
	
	var args = {
		
	}

class NavigationMap:
	var grid: Dictionary
	var dimensions: Vector2

var next_phase: BattlePhase

#var _navigationStack: Array[ActionType]
var _actor: Battler
var _action_result: ActionResult
var _current_navigation_map: NavigationMap

func _init():
	name = "Planning"
	_name = "Planning"

func start_with_params(params):
	super.start_with_params(params)
	
	# TODO: Refactor, make generic
	var change_payload = {}
	change_payload["enable_panel_target"] = "BaseAction"
	change_payload["is_focus"] = true
	change_payload["panel_elements"] = ["Attack", "Defend"]
	
	var cursor_payload = {}
	cursor_payload["cursor_element_indices"] = [0]
	
	ui_change.emit(UIInstructionType.DISABLE_ALL_ACTION_PANELS, {})
	ui_change.emit(UIInstructionType.ENABLE_PANEL, change_payload)
	ui_change.emit(UIInstructionType.SHOW_SELECTION_CURSORS_UI_ELEMENT, cursor_payload)

func _process(_delta):
	_check_player_input()
	

func _check_player_input():
	
	
	# Placeholder
	if Input.is_action_just_pressed("ui_accept"):
		change_condition_met.emit(next_phase, {})

func exit():
	super.exit()
	
	_actor = null

func set_actor(actor: Battler):
	_actor = actor
