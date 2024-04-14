extends PlanningStep

class_name SelectBaseActionPlanningStep
	
# TODO: Change to grid dictionary
func setup_nav_map(elements: Array):
	var dimension_y = mini(elements.size(), 6)
	_navigation_map.dimensions = Vector2(1, dimension_y)
	_navigation_map.load_elements_from_array(elements)

func show(on_ui_change: Callable):
	var commands = _navigation_map.get_elements() as Array[Command]
	var command_names = commands.map(func(cmd: Command): return cmd.get_name())
	var change_payload = {
		"enable_panel_target" = "BaseActionPanel",
		"is_focus" = true,
		"panel_elements" = command_names
	}
	
	var cursor_payload = {
		"cursor_ui_index" = _navigation_map.get_element_index()
	}
	
	if on_ui_change:
		on_ui_change.call(InstructionType.UI.DISABLE_ALL_ACTION_PANELS, {})
		on_ui_change.call(InstructionType.UI.ENABLE_PANEL, change_payload)
		on_ui_change.call(InstructionType.UI.MOVE_SELECTION_CURSOR_UI, cursor_payload)
