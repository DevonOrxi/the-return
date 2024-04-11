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
	
	func set_elements(element_grid: Dictionary):
		_elements = element_grid
	
	func load_elements_from_array(array: Array):
		for i in array.size():
			var x = i % int(dimensions.x)
			var y = i / int(dimensions.x)
			_elements[Vector2(x, y)] = array[i]
	
	func get_current_element():
		return _elements[pointer]
	
	func get_elements() -> Array:
		return _elements.values()
	
	func get_element_index() -> int:
		return pointer.y * dimensions.x + pointer.x

class BattleInfo:
	var _actor: Battler
	var _enemy_units: Array[Battler]
	var _ally_units: Array[Battler]
	
	func _init(actor: Battler, allies: Array[Battler], enemies: Array[Battler]):
		_actor = actor
		_ally_units = allies
		_enemy_units = enemies
	
	func get_actor_commands() -> Array[Command]:
		return _actor.get_commands()

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
			on_ui_change.call(UIInstructionType.DISABLE_ALL_ACTION_PANELS, {})
			on_ui_change.call(UIInstructionType.ENABLE_PANEL, change_payload)
			on_ui_change.call(UIInstructionType.MOVE_SELECTION_CURSOR_UI, cursor_payload)
	
class SelectTargetPlanningStep extends PlanningStep:

	func setup_nav_map(elements: Array):
		var dimension_y = mini(elements.size(), 6)
		_navigation_map.dimensions = Vector2(1, dimension_y)
		_navigation_map.load_elements_from_array(elements)
	
	func show(on_ui_change: Callable):
		var targets = _navigation_map\
			.get_elements()\
			.map(func(element):\
				if element.has_method("get_cursor_anchor"):\
					return element.get_cursor_anchor()\
			)
		
		var change_payload = {
			"enable_panel_target" = "SelectTargetPanel",
			"is_focus" = true,
			"panel_elements" = targets
		}
		
		var cursor_payload = {
			"cursor_ui_index" = _navigation_map.get_element_index(),
			"is_animated" = true,
			"is_flipped_x" = true
		}
		
		if on_ui_change:
			on_ui_change.call(UIInstructionType.DISABLE_ALL_ACTION_PANELS, {})
			on_ui_change.call(UIInstructionType.ENABLE_PANEL, change_payload)
			on_ui_change.call(UIInstructionType.MOVE_SELECTION_CURSOR_UI, cursor_payload)

########################################################

var _next_phase: BattlePhase
var _battle_info: BattleInfo
var _command_stack: Array[Command]
var _current_command: Command
var _planning_stack: Array[PlanningStep]
var _command_ix: int = 0
var _command_step_ix: int = 0

func _init():
	name = "Planning"
	_name = "Planning"

func setup(phase_data: Dictionary = {}):
	# TODO: Refactor
	var actor = phase_data.get("actor") as Battler
	if not actor:
		push_error("ERROR: No actor for Planning Phase!")
	
	var empty: Array[Battler] = []
	var allies: Array[Battler] = phase_data.get("allies", empty)
	var enemies: Array[Battler] = phase_data.get("enemies", empty)
	
	_battle_info = BattleInfo.new(actor, allies, enemies)
	
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
	step.show(_ui_emit)

func _ui_emit(instruction: UIInstructionType, params: Dictionary):
	ui_change.emit(instruction, params)

func _setup_select_base_action():
	# TODO: Extract some
	var commands = _battle_info.get_actor_commands()
	var command_names = commands.map(func(cmd): return cmd.get_name())
	var base_command_step = CommandStep.new()
	var base_command = Command.new()
	var step = SelectBaseActionPlanningStep.new()
	
	base_command._name = "Action Select"
	base_command_step.set_type(CommandStepType.SELECT_BASE_ACTION)
	base_command.set_steps([base_command_step])
	
	step.setup_nav_map(commands)
	step.set_command_step(base_command_step)
	
	_planning_stack.assign([step])
	_command_stack.assign([base_command])
	_current_command = base_command
	_command_ix = 0
	_command_step_ix = 0

func _setup_select_target_enemy_single():
	# TODO: Refactor, hide members behind methods!
	var targets = _battle_info._enemy_units
	var step: PlanningStep = SelectTargetPlanningStep.new()
	
	var current_step = _get_current_command_step()
	
	step.setup_nav_map(targets)
	step.set_command_step(current_step)
	_planning_stack.append(step)

func _setup_current_planning_step():
	var current_command_step = _get_current_command_step()
	
	match current_command_step.get_type():
		CommandStepType.TARGET_ENEMY_SINGLE:
			_setup_select_target_enemy_single()
		_:
			pass

func _handle_current_substep_confirmation():
	var current_planning_step = _get_current_planning_step()
	
	if not current_planning_step:
		push_warning("WARNING: No current substep for confirmation in Planning Phase")
		return
	
	match current_planning_step.get_command_step_type():
		CommandStepType.SELECT_BASE_ACTION:
			var command = _get_current_navigation_map().get_current_element()
			if not command:
				push_warning("WARNING: No command for confirmation in Planning Phase")
				return
				
			_command_stack.append(command)
		_:
			pass

func _handle_accept_input():
	var command_steps_size = _current_command.get_steps().size()
	
	_handle_current_substep_confirmation()

	if _command_step_ix < command_steps_size - 1:
		_command_step_ix += 1
	elif _command_ix < _command_stack.size() - 1:
		_command_step_ix = 0
		_command_ix += 1
		_current_command = _command_stack[_command_ix]
	else:
		## EXECUTE PAPA
		change_condition_met.emit(_next_phase, {})
		
	_setup_current_planning_step()
	_show_current_planning_step()

func _handle_cancel_input():
	var stack_size = _planning_stack.size()
	if stack_size <= 1:
		return
	
	var current = _get_current_planning_step()
	
	if _command_step_ix > 0:
		_command_step_ix -= 1
	elif _command_stack.size() > 1:
		_command_stack.pop_back()
		_command_ix = _command_stack.size() - 1
		_current_command = _command_stack[_command_ix]
		_command_step_ix = _current_command.get_steps().size() - 1
	
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
	if nav_map.dimensions == Vector2.ZERO:
		return
	
	nav_map.move_pointer_by(i_vec)
	
	var cursor_payload = {
		"cursor_ui_index" = nav_map.get_element_index()
	}
	
	_ui_emit(UIInstructionType.MOVE_SELECTION_CURSOR_UI, cursor_payload)

func _get_current_command_step() -> CommandStep:
	var command = _command_stack[_command_ix]
	var steps = command.get_steps()
	return steps[_command_step_ix]

func _get_current_planning_step() -> PlanningStep:
	return _planning_stack.back()

func _get_current_navigation_map() -> NavigationMap:
	return _get_current_planning_step().get_navigation_map()
