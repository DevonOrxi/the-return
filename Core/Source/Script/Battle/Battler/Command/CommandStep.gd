
class_name CommandStep

const CommandStepType = InstructionType.CommandStepType

var _type: CommandStepType
var _action_components: Dictionary

func get_type() -> CommandStepType:
	return _type

func set_type(type: CommandStepType):
	_type = type

func set_action_components(action_components: Dictionary):
	_action_components = action_components
