extends BattleActionStep

class_name ShowDamageActionStep

var damage_text: String
var damage_position: Vector2

func set_command_config_values(dictionary: Dictionary):
	super.set_command_config_values(dictionary)
	
	var damage_x = dictionary.get("damage_position_x", 0)
	var damage_y = dictionary.get("damage_position_y", 0)
	
	if Assert.is_null_that_warns(damage_x):
		damage_x = 0
	
	if Assert.is_null_that_warns(damage_y):
		damage_y = 0
	
	damage_position = Vector2(damage_x, damage_y)
	
	damage_text = dictionary.get("damage_amount")
