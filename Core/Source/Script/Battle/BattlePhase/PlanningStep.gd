
class_name PlanningStep

const CommandStepType = InstructionType.CommandStepType

var _navigation_map: NavigationMap = NavigationMap.new()
var _command_type: CommandStepType
var _partial_action_components: Dictionary

func _init(action_components: Dictionary):
	_partial_action_components = action_components

func set_command_type(command_type: CommandStepType):
	_command_type = command_type

@warning_ignore("unused_parameter")
func setup_nav_map(elements: Array):
	pass

func get_navigation_map():
	return _navigation_map

func get_command_step_type() -> CommandStepType:
	return _command_type

@warning_ignore("unused_parameter")
func show(on_ui_change: Callable):
	pass

@warning_ignore("unused_parameter")
func get_next_action_components(params: Array) -> Dictionary:
	return {}
