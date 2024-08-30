extends BattlePhase

class_name PlanningBattlePhase

const CommandStepType = InstructionType.CommandStepType

var _next_phase: BattlePhase
var _battle_info: BattleInfo
var _command_stack: Array[Command]
var _current_command: Command
var _planning_stack: Array[PlanningStep]
var _command_ix: int = 0
var _command_step_ix: int = 0

#region Lifecycle

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
	
	_initialize_command_stack()
	_setup_current_planning_step({})

func _initialize_command_stack():
	var first_step_type = CommandStepType.SELECT_BASE_ACTION
	
	var base_command = Command.new()
	base_command._name = "Action Select"
	base_command.set_steps([first_step_type])
	
	_command_ix = 0
	_command_step_ix = 0
	
	_command_stack.append(base_command)
	_current_command = base_command

func start():
	super.start()
	
	_show_current_planning_step()

func _process(_delta):
	_check_player_input()

func exit():
	super.exit()
	
	_battle_info = null
#endregion

#region Phase Management

func set_next_phase(phase: BattlePhase):
	_next_phase = phase

func _go_to_next_phase(last_action_components: Dictionary):
	change_condition_met.emit(_next_phase, last_action_components)
#endregion

# TODO: Regions
func _show_current_planning_step():
	var step = _get_current_planning_step()
	# TODO: add battler signal or sth
	step.show(_ui_emit)

# TODO: Regions
func _ui_emit(instruction: UIInstructionType, params: Dictionary):
	ui_change.emit(instruction, params)

#region Step & Command Setup

func _setup_current_planning_step(next_action_components: Dictionary):
	var current_command_step_type = _get_current_command_step_type()
	
	match current_command_step_type:
		CommandStepType.SELECT_BASE_ACTION:
			_setup_select_base_action(next_action_components)
		CommandStepType.TARGET_ENEMY_SINGLE:
			_setup_select_target_enemy_single(next_action_components)
		_:
			pass

func _setup_select_base_action(next_action_components: Dictionary):
	# TODO: Extract some
	var commands = _battle_info.get_actor_commands()
	#var command_names = commands.map(func(cmd): return cmd.get_name())
	var step = SelectBaseActionPlanningStep.new(next_action_components)
	
	step.setup_nav_map(commands)
	_planning_stack.append(step)

func _setup_select_target_enemy_single(next_action_components: Dictionary):
	# TODO: Refactor, hide members behind methods!
	var targets = _battle_info._enemy_units
	var step = SelectTargetPlanningStep.new(next_action_components)
	
	step.setup_nav_map(targets)
	_planning_stack.append(step)

func _prepare_next_command_steps():
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
#endregion

#region Input Handlers

func _check_player_input():
	if Input.is_action_just_pressed("ui_accept"):
		_handle_accept_input()
	elif Input.is_action_just_pressed("ui_cancel"):
		_handle_cancel_input()
	else:
		_handle_movement_input()

func _handle_accept_input():
	var next_action_components = _get_next_action_components()
	_prepare_next_command_steps()
	
	if _is_last_command_step():
		_go_to_next_phase(next_action_components)
		return
	
	_increment_command_stack_ixs()
	_setup_current_planning_step(next_action_components)
	_show_current_planning_step()

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
#endregion

#region Command Stack Index

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
#endregion

#region Helpers

func _get_current_command_step_type() -> CommandStepType:
	var command = _command_stack[_command_ix]
	var steps = command.get_steps()
	return steps[_command_step_ix]

func _get_next_action_components() -> Dictionary:
	# TODO: Generalize
	var current_planning_step = _get_current_planning_step()
	var next_action_components = {}
	
	# TODO: Generalize!!!
	match current_planning_step.get_command_step_type():
		_:
			var element = _get_current_navigation_map().get_current_element()
			var components = current_planning_step.get_next_action_components([element])
			next_action_components.merge(components)
	
	return next_action_components

func _is_last_command_step() -> bool:
	var next_ix = _command_step_ix + 1
	var steps_in_command = _current_command.get_amount_of_steps()
	return next_ix >= steps_in_command and _command_ix >= _command_stack.size() - 1 

func _get_current_planning_step() -> PlanningStep:
	return _planning_stack.back()

func _get_current_navigation_map() -> NavigationMap:
	return _get_current_planning_step().get_navigation_map()
#endregion
