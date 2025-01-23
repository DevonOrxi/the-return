extends ExecutionBuildingBlock

class_name ShowDamageBuildingBlock

var damage_text: String
var damage_position: Vector2

func set_values(dictionary: Dictionary):
	super.set_values(dictionary)
	
	var damage_x = dictionary.get("damage_position_x") as float
	var damage_y = dictionary.get("damage_position_y") as float
	damage_position = Vector2(damage_x, damage_y)
	
	damage_text = dictionary.get("damage_position_y")
