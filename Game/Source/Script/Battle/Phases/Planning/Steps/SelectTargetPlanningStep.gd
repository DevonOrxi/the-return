extends PlanningStep

class_name SelectTargetPlanningStep

func _init(action_components: Dictionary):
	super(action_components)
	
	# TODO: Figure out generalistic approach
	_command_type = CommandStepType.TARGET_ALLY_SINGLE

func setup_nav_map(elements: Array):
	var dimension_y = mini(elements.size(), 6)
	_navigation_map.dimensions = Vector2(1, dimension_y)
	_navigation_map.load_elements_from_array(elements)

func show(on_ui_change: Callable):
	var targets = _navigation_map.get_elements()
	
	var change_payload = {
		"enable_panel_target" = "SelectTargetPanel",
		"is_focus" = true,
		"panel_elements" = targets
	}
	
	var cursor_payload = {
		"cursor_ui_index" = _navigation_map.get_element_index(),
		"is_animated" = false,
		"is_flipped_x" = true
	}
	
	if on_ui_change:
		on_ui_change.call(InstructionType.UI.DISABLE_ALL_ACTION_PANELS, {})
		on_ui_change.call(InstructionType.UI.ENABLE_PANEL, change_payload)
		on_ui_change.call(InstructionType.UI.MOVE_SELECTION_CURSOR_UI, cursor_payload)

func get_next_action_components(params: Array) -> Dictionary:
	var battlers = params.filter(func(param): return param is Battler)
	if battlers.size() <= 0:
		return _partial_action_components
	
	var components = {
		"targets": battlers
	}
	
	components.merge(_partial_action_components, true)
	
	return components
