extends Battler

class_name PlayerBattler

var _commands: Array[Command]

func _init():
	_commands = [
		AttackCommand.new(),
		DefendCommand.new(),
	]
	
	_name = "Paladin"
	_flipped_pointer = false

func get_commands() -> Array[Command]:
	return _commands
