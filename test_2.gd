extends Node2D

func _init() -> void:
	var command_null: Command = null
	var any_null = null
	
	if not command_null or not command_null is Command:
		print("1 is null")
		print("1 is not Command")
	
	if not any_null or not any_null is Command:
		print("2 is null")
		print("2 is not Command")
