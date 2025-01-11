
class_name Command

const CommandStepType = Enum.CommandStepType

var _name: String
var _id: String
var _steps: Array[CommandStepType] = []
var _execution_plan: Dictionary
	
func get_name() -> String:
	return _name

func get_id() -> String:
	return _id

func set_steps(steps: Array[CommandStepType]):
	_steps = steps

func get_steps() -> Array[CommandStepType]:
	return _steps
	
func get_amount_of_steps() -> int:
	return _steps.size()
