extends BattlePhase

class_name PlanningBattlePhase

enum ActionType {
	SELECT_ACTOR,
	SELECT_BASE_ACTION,
	SELECT_ABILITY,
	ABILITY_SPECIFICS,
	TARGET_ONE_ROW,
	TARGET_TWO_ROW,
	WAIT,
	EXECUTE
}

class Action:
	#var _stack: Array[ActionType]
	#var _stack_pointer = 0
	var name: String
	var args: Array

class ActionInput:
	
	var args = {
		
	}

var next_phase: BattlePhase

#var _navigationStack: Array[ActionType]
var _actor: Battler

func _init():
	name = "Planning"
	_name = "Planning"

func start_with_params(params):
	super.start_with_params(params)
	
	var disable_panels = {}
	disable_panels["action"] = "disable_all_action_panels"
	
	var change_panel = {}
	change_panel["action"] = "enable_action_panel"
	change_panel["enable_panel_target"] = "BaseAction"
	change_panel["is_focus"] = true
	
	ui_change.emit(disable_panels)
	ui_change.emit(change_panel)
	

func _process(_delta):
	# Placeholder
	if Input.is_action_just_pressed("ui_accept"):
		change_condition_met.emit(next_phase)

func exit():
	super.exit()
	
	_actor = null

func set_actor(actor: Battler):
	_actor = actor
