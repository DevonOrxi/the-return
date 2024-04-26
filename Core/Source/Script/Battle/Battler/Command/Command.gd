
class_name Command

const CommandStepType = InstructionType.CommandStepType

var _name: String
var _steps: Array[CommandStepType] = []
	
func get_name() -> String:
	return _name

func set_steps(steps: Array[CommandStepType]):
	_steps = steps

func get_steps() -> Array[CommandStepType]:
	return _steps
	
func get_amount_of_steps() -> int:
	return _steps.size()
