class_name PlanningStep

const CommandStepType = Enum.CommandStepType

var _navigation_map: CursorNavigationMap = CursorNavigationMap.new()
var _command_type: CommandStepType

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
