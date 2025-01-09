extends BattlePhase

class_name PlanningBattlePhase

const CommandStepType = InstructionType.CommandStepType

var _next_phase: BattlePhase
var _battle_info: BattleInfo
var _planning_result: PlanningPhaseResult
var _planning_step_stack: Array[PlanningStep]
var _planning_command_map: PlanningCommandMap

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
	
	_planning_result = PlanningPhaseResult.new()
	_planning_command_map = PlanningCommandMap.new()
	_battle_info = BattleInfo.new(actor, allies, enemies)
	
	_planning_result.actor = actor # For now
	
	_setup_current_planning_step()

func start(with_params: Dictionary = {}):
	super.start(with_params)
	
	_show_current_planning_step()

func _process(_delta):
	_check_player_input()

func exit():
	super.exit()
	
	_battle_info = null
	_planning_command_map = null
	_planning_step_stack = []
#endregion

#region Phase Management

func set_next_phase(phase: BattlePhase):
	_next_phase = phase

func _go_to_next_phase():
	change_condition_met.emit(_next_phase, _planning_result)
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
func _setup_current_planning_step():
	var current_command_step_type = _planning_command_map.get_current_command_step_type()
	var step: PlanningStep
	# TODO: Generalize!
	match current_command_step_type:
		CommandStepType.SELECT_BASE_ACTION:
			step = _get_select_base_action()
		CommandStepType.TARGET_ENEMY_SINGLE:
			step = _get_select_target_enemy_single()
		_:
			pass
	
	if step:
		_planning_step_stack.append(step)
	else:
		push_warning("WARNING: No new step for stack")

func _get_select_base_action() -> PlanningStep:
	# TODO: Extract some
	var commands = _battle_info.get_actor_commands()
	var step = SelectBaseActionPlanningStep.new()
	step.setup_nav_map(commands)
	return step

func _get_select_target_enemy_single()-> PlanningStep:
	# TODO: Refactor, hide members behind methods!
	var targets = _battle_info._enemy_units
	var step = SelectTargetPlanningStep.new()
	step.setup_nav_map(targets)
	return step

func _prepare_next_command_steps():
	var current_planning_step = _get_current_planning_step()
	
	if not current_planning_step:
		push_warning("WARNING: No current substep for confirmation in Planning Phase")
		return
	
	match current_planning_step.get_command_step_type():
		CommandStepType.SELECT_BASE_ACTION:
			var command = _get_current_nav_map_element()
			if not command or not command is Command:
				push_warning("WARNING: No command for confirmation in Planning Phase")
				return
			
			_planning_command_map.append_to_stack(command)
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
	_store_action_components_on_accept()
	_prepare_next_command_steps()
	
	if _is_last_command_step():
		_go_to_next_phase()
		return
	
	_planning_command_map.increment_command_stack_ixs()
	_setup_current_planning_step()
	_show_current_planning_step()

func _handle_cancel_input():
	if _planning_step_stack.size() <= 1:
		return
	
	_erase_action_components_on_back()
	_planning_step_stack.pop_back()
	
	_planning_command_map.decrement_commmand_stack_ixs()
	_show_current_planning_step()

func _handle_movement_input():
	var y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	var x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	
	if not x and not y:
		return
	
	var i_vec = Vector2(x, y)
	var nav_map = _get_current_navigation_map()
	if nav_map.get_dimensions() == Vector2.ZERO:
		return
	
	nav_map.move_pointer_by(i_vec)
	var element = nav_map.get_current_element()
	var is_flipped_x: bool
	
	if element.has_method("has_flipped_pointer"):
		is_flipped_x = element.has_flipped_pointer()
	else:
		is_flipped_x = false
	
	var cursor_payload = {
		"cursor_ui_index" = nav_map.get_current_element_index(),
		"is_flipped_x" = is_flipped_x
	}
	
	_ui_emit(UIInstructionType.MOVE_SELECTION_CURSOR_UI, cursor_payload)
#endregion



#region Helpers
func _erase_action_components_on_back():
	_update_action_components(true)

func _store_action_components_on_accept():
	_update_action_components(false)

func _update_action_components(erasing: bool = false):
	# TODO: Generalize
	var current_planning_step = _get_current_planning_step()
	var step_type = current_planning_step.get_command_step_type()
	
	# TODO: Generalize!!!
	var components: Dictionary
	match step_type:
		CommandStepType.SELECT_BASE_ACTION:
			var command = _planning_command_map.get_current_command() if not erasing else null
			_planning_result.command = command
		CommandStepType.TARGET_ENEMY_SINGLE:
			var element = _get_current_nav_map_element() if not erasing else null
			_planning_result.primary_targets = [element]

func _get_current_planning_step() -> PlanningStep:
	return _planning_step_stack.back()

func _get_current_navigation_map() -> NavigationMap:
	var current_planning_step = _get_current_planning_step()
	return current_planning_step.get_navigation_map()

func _is_last_command_step() -> bool:
	return _planning_command_map.is_last_command_step()
	
func _get_current_nav_map_element():
	var nav_map = _get_current_navigation_map()
	return nav_map.get_current_element()
#endregion
