extends BattlePhase

class_name ExecutionBattlePhase

const BlockType = Enum.ExecutionBuildingBlockType

var _execution_instruction_builder: ExecutionInstructionBuilder

signal execution_command_ready(plan: ExecutionInstruction)

func _init():
	name = "Execution"
	_name = "Execution"

func start(previous_phase_result: Dictionary = {}):
	super.start(previous_phase_result)
	
	_execution_instruction_builder = ExecutionInstructionBuilder.new()
	
	var command: Command = previous_phase_result.get("command")
	Assert.is_null_that_fails(command, "ERROR: No command for execution builder") 
	
	var blueprint = command.get_blueprint_duplicate()
	
	var actual_plan = ExecutionInstructionBuilder.build(blueprint, previous_phase_result)
	execution_command_ready.emit(actual_plan)

func exit():
	super.exit()
