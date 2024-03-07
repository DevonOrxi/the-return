extends Node

class_name NavigationController

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

var _navigationStack: Array[ActionType]
var _navigationPointer = Vector2.ZERO
var _navigationMap: Array

func start(actors: Array):
	_navigationMap = actors
	_navigationStack.append(ActionType.SELECT_ACTOR)
	pass

func present(type: ActionInput):
	pass

func _commit():
	pass

func _back():
	pass

func _on_input_manager_signal(dir: Vector2, accept: bool, cancel: bool):
	if accept:
		_commit()
	elif cancel:
		_back()
	_navigationPointer += dir
	
	pass # Replace with function body.
