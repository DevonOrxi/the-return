extends Node2D

class_name Battler

var _commands: Array[Command]

func _init():
	_commands = [
		AttackCommand.new(),
		DefendCommand.new(),
	]

func get_commands() -> Array[Command]:
	return _commands
