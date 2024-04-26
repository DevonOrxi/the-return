extends BattlePhase

class_name PlanningBattlePhase

const CommandStepType = InstructionType.CommandStepType

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
	_initialize_command_stack()

func _initialize_command_stack():
	var current_planning_step_type = _get_current_planning_step().get_command_step_type()
	if current_planning_step_type == null:
		push_warning("WARNING: No planning step to initialize command stack")
		return
	
	var base_command = Command.new()
	base_command._name = "Action Select"
	base_command.set_steps([current_planning_step_type])
	
	_command_ix = 0
	_command_step_ix = 0
	
	_command_stack.append(base_command)
	_current_command = base_command

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
	#var command_names = commands.map(func(cmd): return cmd.get_name())
	var step = SelectBaseActionPlanningStep.new({})
	var command_type = CommandStepType.SELECT_BASE_ACTION
	
	step.setup_nav_map(commands)
	step.set_command_type(command_type)
	
	_planning_stack.append(step)

func _setup_select_target_enemy_single():
	# TODO: Refactor, hide members behind methods!
	var targets = _battle_info._enemy_units
	var current_c_type = _get_current_command_step_type()
	var current_p_step = _get_current_planning_step()
	var new_partials = current_p_step.get_next_action_components()
	var step: PlanningStep = SelectTargetPlanningStep.new(new_partials)
	
	step.setup_nav_map(targets)
	step.set_command_type(current_c_type)
	_planning_stack.append(step)

func _setup_current_planning_step():
	var current_command_step_type = _get_current_command_step_type()
	
	match current_command_step_type:
		CommandStepType.SELECT_BASE_ACTION:
			_setup_select_base_action()
		CommandStepType.TARGET_ENEMY_SINGLE:
			_setup_select_target_enemy_single()
		_:
			pass

func _handle_current_substep_confirmation(is_last_command_step: bool):
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
	var is_last_command_step = _is_last_command_step()
	_handle_current_substep_confirmation(is_last_command_step)
	
	if _is_last_command_step():
		_go_to_next_phase()
		return
	
	_increment_command_stack_ixs()
	_setup_current_planning_step()
	_show_current_planning_step()

func _increment_command_stack_ixs():
	var current_command_steps = _current_command.get_amount_of_steps()
	if _command_step_ix < current_command_steps - 1:
		_command_step_ix += 1
	elif _command_ix < _command_stack.size() - 1:
		_command_step_ix = 0
		_command_ix += 1
		_current_command = _command_stack[_command_ix]

func _decrement_commmand_stack_ixs():
	if _command_step_ix > 0:
		_command_step_ix -= 1
	elif _command_stack.size() > 1:
		_command_stack.pop_back()
		_command_ix = _command_stack.size() - 1
		_current_command = _command_stack[_command_ix]
		_command_step_ix = _current_command.get_steps().size() - 1

func _handle_cancel_input():
	if _planning_stack.size() <= 1:
		return
	
	_planning_stack.pop_back()
	
	_decrement_commmand_stack_ixs()
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

func _go_to_next_phase():
	# TODO: Review
	var planning_step = _get_current_planning_step()
	var last_partial = planning_step.get_next_action_components()
	change_condition_met.emit(_next_phase, last_partial)

func _get_current_command_step_type() -> CommandStepType:
	var command = _command_stack[_command_ix]
	var steps = command.get_steps()
	return steps[_command_step_ix]

func _is_last_command_step() -> bool:
	var next_ix = _command_step_ix + 1
	var steps_in_command = _current_command.get_amount_of_steps()
	return next_ix >= steps_in_command and _command_ix >= _command_stack.size() - 1 

func _get_current_planning_step() -> PlanningStep:
	return _planning_stack.back()

func _get_current_navigation_map() -> NavigationMap:
	return _get_current_planning_step().get_navigation_map()
