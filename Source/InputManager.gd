extends Node

signal inputSignal(dir: Vector2, accept: bool, cancel: bool)

func _process(delta):
	var y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	var x = int(Input.is_action_just_pressed("ui_left")) - int(Input.is_action_just_pressed("ui_right"))
	var accept = Input.is_action_just_pressed("ui_accept")
	var cancel = Input.is_action_just_pressed("ui_cancel")
	
	inputSignal.emit(Vector2(x, y), accept, cancel)
