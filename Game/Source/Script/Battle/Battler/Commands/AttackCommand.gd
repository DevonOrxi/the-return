extends Command

class_name AttackCommand

const CommandStepType = InstructionType.CommandStepType

func _init():
	_name = "Attack"
	
	var step = CommandStep.new()
	step.set_type(CommandStepType.TARGET_ALLY_SINGLE)
	_steps.assign([step])
