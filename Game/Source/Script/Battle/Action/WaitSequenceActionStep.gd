extends BattleActionStep

class_name WaitActionStep

var waiting_time: float

func set_command_config_values(dictionary: Dictionary):
	super.set_command_config_values(dictionary)
	
	waiting_time = dictionary.get("waiting_time", 0.0)
