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
	var _stack: Array[ActionType]
	var _stack_pointer = 0
	var name: String
	var args: Array

class ActionInput:
	
	var args = {
		
	}

var next_phase: BattlePhase

var _navigationStack: Array[ActionType]
var _actor: Battler

func _init():
	name = "Planning"
	_name = "Planning"

func start():
	super.start()
	

func _process(delta):
	# Placeholder
	if Input.is_action_just_pressed("ui_accept"):
		change_condition_met.emit(next_phase)

func exit():
	super.exit()
	
	_actor = null

func set_actor(actor: Battler):
	_actor = actor
