class_name PlanningCommandMap

var _command_ix: int
var _command_step_ix: int
var _command_stack: Array[Command]
var _current_command: Command

const CommandStepType = InstructionType.CommandStepType

func _init():
	_command_ix = 0
	_command_step_ix = 0
	
	var first_step_type = CommandStepType.SELECT_BASE_ACTION
	
	var base_command = Command.new()
	base_command._name = "Action Select"
	base_command.set_steps([first_step_type])
	
	_command_stack.append(base_command)
	_current_command = base_command

func append_to_stack(command: Command):
	_command_stack.append(command)

func get_current_command_step_type() -> CommandStepType:
	var command = get_current_command()
	var steps = command.get_steps()
	return steps[_command_step_ix]

func is_last_command_step() -> bool:
	var next_ix = _command_step_ix + 1
	var steps_in_command = _current_command.get_amount_of_steps()
	return next_ix >= steps_in_command and _command_ix >= _command_stack.size() - 1 

func get_current_command() -> Command:
	return _command_stack[_command_ix]

func increment_command_stack_ixs():
	var current_command_steps = _current_command.get_amount_of_steps()
	if _command_step_ix < current_command_steps - 1:
		_command_step_ix += 1
	elif _command_ix < _command_stack.size() - 1:
		_command_step_ix = 0
		_command_ix += 1
		_current_command = _command_stack[_command_ix]

func decrement_commmand_stack_ixs():
	if _command_step_ix > 0:
		_command_step_ix -= 1
	elif _command_stack.size() > 1:
		_command_stack.pop_back()
		_command_ix = _command_stack.size() - 1
		_current_command = _command_stack[_command_ix]
		_command_step_ix = _current_command.get_steps().size() - 1
