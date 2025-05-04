extends ExecutionBuildingBlock

class_name AnimateBattlerBuildingBlock

var animation_name: String
var animation_looping: bool
var animation_target: Battler

func set_command_config_values(dictionary: Dictionary):
	super.set_command_config_values(dictionary)
	
	animation_name = dictionary.get("animation")
	animation_looping = dictionary.get("looping")
	
	var battler = dictionary.get("target")
	if battler is Battler:
		animation_target = battler
