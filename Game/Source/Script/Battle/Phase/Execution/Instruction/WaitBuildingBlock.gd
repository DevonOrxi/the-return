extends ExecutionBuildingBlock

class_name WaitBuildingBlock

var waiting_time: float

func set_values(dictionary: Dictionary):
	super.set_values(dictionary)
	
	waiting_time = dictionary.get("waiting_time", 0.0)
