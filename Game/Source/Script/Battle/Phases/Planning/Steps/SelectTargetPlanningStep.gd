extends PlanningStep

class_name SelectTargetPlanningStep

func _init():
	# TODO: Figure out generalistic approach
	_command_type = CommandStepType.TARGET_ENEMY_SINGLE

func setup_nav_map(elements: Array):
	# TODO: RARI
	var dimension_y = mini(elements.size(), 6)
	var dimensions = Vector2(1, dimension_y)
	_navigation_map.set_dimensions(dimensions)
	_navigation_map.load_elements_from_array(elements)

func show(on_ui_change: Callable):
	var targets = _navigation_map.get_elements()
	
	var change_payload = {
		"enable_panel_target" = "SelectTargetPanel",
		"is_focus" = true,
		"panel_elements" = targets
	}
	
	var cursor_payload = {
		"cursor_ui_index" = _navigation_map.get_current_element_index(),
		"is_animated" = false,
		"is_flipped_x" = true
	}
	
	if on_ui_change:
		on_ui_change.call(InstructionType.UI.DISABLE_ALL_ACTION_PANELS, {})
		on_ui_change.call(InstructionType.UI.ENABLE_PANEL, change_payload)
		on_ui_change.call(InstructionType.UI.MOVE_SELECTION_CURSOR_UI, cursor_payload)
