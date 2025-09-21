@abstract class_name Command

const CommandStepType = Enum.CommandStepType

var _name: String
var _id: String
var _steps: Array[CommandStepType] = []
var _blueprint_json: JSON

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

func get_blueprint_duplicate() -> Dictionary:
	var dict = _blueprint_json.data as Dictionary
	Assert.is_null_that_fails(dict)
	return dict.duplicate(true)
