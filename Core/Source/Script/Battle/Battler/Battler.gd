extends Node2D

class_name Battler

@onready var _cursor_anchor = $TargetIndictatorPosition

var _commands: Array[Command]

func _init():
	_commands = [
		AttackCommand.new(),
		DefendCommand.new(),
	]

func get_commands() -> Array[Command]:
	return _commands

func get_cursor_anchor() -> Vector2:
	return _cursor_anchor
