extends BattlePhase

class_name PlanningBattlePhase

const CommandStepType = InstructionType.CommandStepType

class NavigationMap:
	var _elements: Dictionary
	
	var looping: bool
	var dimensions: Vector2
	var pointer: Vector2 = Vector2.ZERO
	
	func move_pointer_by(movement: Vector2):
		var result = pointer + movement
		
		# TODO: Check for empty positions
		if looping:
			result.x %= dimensions.x
			result.y %= dimensions.y
		else:
			if result.x >= dimensions.x:
				result.x = dimensions.x - 1
			elif result.x <= 0:
				result.x = 0
				
			if result.y >= dimensions.y:
				result.y = dimensions.y - 1
			elif result.y <= 0:
				result.y = 0
		
		pointer = result
	
	func load_elements(array: Array):
		for i in array.size():
			var x = i % int(dimensions.x)
			var y = i / int(dimensions.x)
			_elements[Vector2(x, y)] = array[i]
	
	func get_current_element() -> Vector2:
		return _elements[pointer]
	
	func get_elements() -> Array:
		return _elements.values()
	
	func get_element_index() -> int:
		return pointer.y * dimensions.x + pointer.x

class BattleInfo:
	var actor: Battler

class PlanningStep:
	var _navigation_map: NavigationMap = NavigationMap.new()
	var _command_step: CommandStep
	
	func set_command_step(command_step: CommandStep):
		_command_step = command_step
	
	func setup_nav_map(elements: Array):
		pass
	
	func get_navigation_map():
		return _navigation_map
	
	func get_command_step_type():
		return _command_step.get_type()
	
	func show(on_ui_change: Callable):
		pass

class SelectBaseActionPlanningStep extends PlanningStep:
	
	func setup_nav_map(elements: Array):
		var dimension_y = mini(elements.size(), 6)
		_navigation_map.dimensions = Vector2(1, dimension_y)
		_navigation_map.load_elements(elements)
	
	func show(on_ui_change: Callable):
		var command_names = _navigation_map.get_elements() as Array[Command]
		var change_payload = {
			"enable_panel_target" = "BaseAction",
			"is_focus" = true,
			"panel_elements" = command_names
		}
		
		var cursor_payload = {
			"cursor_element_indices" = [_navigation_map.get_element_index()]
		}
		
		if on_ui_change:
			on_ui_change.call(UIInstructionType.DISABLE_ALL_ACTION_PANELS, {})
			on_ui_change.call(UIInstructionType.ENABLE_PANEL, change_payload)
			on_ui_change.call(UIInstructionType.SHOW_SELECTION_CURSORS_UI_ELEMENT, cursor_payload)

########################################################

var _next_phase: BattlePhase
var _battle_info: BattleInfo
var _command_stack: Array[Command]
var _current_command: Command
var _planning_stack: Array[PlanningStep]
var _command_step_ix: int = 0

func _init():
	name = "Planning"
	_name = "Planning"

func setup(phase_data: Dictionary = {}):
	_battle_info = BattleInfo.new()
	
	var actor = phase_data["actor"] as Battler
	if not actor:
		push_error("ERROR: No actor for Planning Phase!")
	
	_battle_info.actor = actor
	
	_setup_select_base_action()

func start():
	super.start()
	
	_show_current_planning_step()

func _process(_delta):
	_check_player_input()

func _check_player_input():
	if Input.is_action_just_pressed("ui_accept"):
		_handle_accept_input()
	elif Input.is_action_just_pressed("ui_cancel"):
		_handle_cancel_input()
	else:
		_handle_movement_input()

func exit():
	super.exit()
	
	_battle_info = null

func set_next_phase(phase: BattlePhase):
	_next_phase = phase

func _show_current_planning_step():
	var step = _planning_stack.back()
	step.show(_on_planning_step_ui_emit)

func _on_planning_step_ui_emit(instruction: UIInstructionType, params: Dictionary):
	ui_change.emit(instruction, params)
	

func _setup_select_base_action():
	var commands = _get_actor_commands()
	var command_names = commands.map(func(cmd): return cmd.get_name())
	var base_command_step = CommandStep.new()
	var step = SelectBaseActionPlanningStep.new()
	
	base_command_step.set_type(CommandStepType.SELECT_BASE_ACTION)
	
	step.setup_nav_map(command_names)
	step.set_command_step(base_command_step)
	_planning_stack.append(step)

func _setup_current_substep():
	var current_planning_step = _get_current_planning_step()
	
	match current_planning_step.get_command_step_type():
		CommandStepType.SELECT_BASE_ACTION:
			_setup_select_base_action()
		CommandStepType.TARGET_ENEMY_SINGLE:
			pass
		_:
			pass

func _handle_current_substep_confirmation():
	var current_planning_step = _get_current_planning_step()
	
	if not current_planning_step:
		push_warning("WARNING: No current substep for confirmation in Planning Phase")
		return
	
	match current_planning_step.get_command_step_type():
		CommandStepType.SELECT_BASE_ACTION:
			pass
		_:
			pass

func _handle_accept_input():
	var command_steps_size = _current_command.get_steps().size()
	var command_stack_old_size = _command_stack.size()
	
	_handle_current_substep_confirmation()

	if _command_step_ix < command_steps_size - 1:
		_command_step_ix += 1
	elif _command_stack.size() > command_stack_old_size:
		_command_step_ix = 0
		_current_command = _command_stack.back()
	else:
		## EXECUTE PAPA
		change_condition_met.emit(_next_phase, {})
		
	_setup_current_substep()
	_show_current_planning_step()
	

func _handle_cancel_input():
	var stack_size = _planning_stack.size()
	if stack_size <= 1:
		return
	
	var current = _get_current_planning_step()
	
	if _command_step_ix > 0:
		_command_step_ix -= 1
	elif _command_stack.size() >= 1:
		_command_stack.pop_back()
		_current_command = _command_stack.back()
		_command_step_ix = _command_stack.size() - 1
	
	_planning_stack.pop_back()
	
	if _planning_stack.is_empty():
		_setup_select_base_action()
	
	_show_current_planning_step()

func _handle_movement_input():
	var y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	var x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	var i_vec = Vector2(x, y)
	
	if not x and not y:
		return
	
	var nav_map = _get_current_navigation_map()
	nav_map.move_pointer_by(i_vec)
	
	var cursor_payload = {
		"cursor_element_indices" = [nav_map.get_element_index()]
	}
	
	ui_change.emit(UIInstructionType.CLEAR_ALL_SELECTION_CURSORS, {})
	ui_change.emit(UIInstructionType.SHOW_SELECTION_CURSORS_UI_ELEMENT, cursor_payload)

func _get_current_command_step() -> CommandStep:
	var command = _command_stack.back()
	return command[_command_step_ix]

func _get_actor_commands() -> Array[Command]:
	return _battle_info.actor.get_commands()

func _get_current_planning_step() -> PlanningStep:
	return _planning_stack.back()

func _get_current_navigation_map() -> NavigationMap:
	return _get_current_planning_step().get_navigation_map()
