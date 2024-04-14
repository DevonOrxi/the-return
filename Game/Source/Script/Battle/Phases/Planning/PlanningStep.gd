
class_name PlanningStep

var _navigation_map: NavigationMap = NavigationMap.new()
var _command_step: CommandStep
var _partial_action_components: Dictionary

func _init(action_components: Dictionary):
	_partial_action_components = action_components

func set_command_step(command_step: CommandStep):
	_command_step = command_step

@warning_ignore("unused_parameter")
func setup_nav_map(elements: Array):
	pass

func get_navigation_map():
	return _navigation_map

func get_command_step_type():
	return _command_step.get_type()

@warning_ignore("unused_parameter")
func show(on_ui_change: Callable):
	pass

func get_next_action_components() -> Dictionary:
	var new_components = _partial_action_components.duplicate(true)
	var command_components = _command_step.get_action_components()
	new_components.merge(command_components, true)
	return new_components
