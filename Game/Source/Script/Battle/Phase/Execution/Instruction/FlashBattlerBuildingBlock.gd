extends ExecutionBuildingBlock

class_name FlashBattlerBuildingBlock

var flashing_target: Battler
var flashing_color: Color

func set_command_config_values(dictionary: Dictionary):
	super.set_command_config_values(dictionary)
	
	var battler = dictionary.get("target")
	if battler is Battler:
		flashing_target = battler
	
	var color_string = dictionary.get("color")
	if Assert.is_null(color_string):
		flashing_color = Color(color_string)
