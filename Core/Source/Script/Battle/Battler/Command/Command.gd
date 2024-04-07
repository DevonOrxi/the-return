
class_name Command

var _name: String
var _steps: Array[CommandStep] = []
	
func get_name() -> String:
	return _name

func set_steps(steps: Array[CommandStep]):
	_steps = steps

func get_steps() -> Array[CommandStep]:
	return _steps
