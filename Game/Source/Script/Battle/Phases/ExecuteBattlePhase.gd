extends BattlePhase

class_name ExecuteBattlePhase

class ExecutionInstructionBuilder:
	pass

var _execution_instruction: ExecutionInstruction
var _execution_instruction_builder := ExecutionInstructionBuilder.new()

func _init():
	name = "Execute"
	_name = "Execute"

func start(previous_phase_result: PhaseResult = null):
	super.start(previous_phase_result)
	
	# Get command
	# Get command dictionary / parsed JSON file
	# Pass dictionary to builder
	# Store execution instruction
	# Execute Order 66

func exit():
	super.exit()
