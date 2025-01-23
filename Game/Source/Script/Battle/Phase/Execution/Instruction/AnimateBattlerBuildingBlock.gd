extends ExecutionBuildingBlock

class_name AnimateBattlerBuildingBlock

var animation_name: String
var animation_looping: bool
var animation_target: Battler

func set_values(dictionary: Dictionary):
	super.set_values(dictionary)
	
	animation_name = dictionary.get("animation_name")
	animation_looping = dictionary.get("animation_looping")
	
	var battler = dictionary.get("animation_target")
	if battler is Battler:
		animation_target = battler
