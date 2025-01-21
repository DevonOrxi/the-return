extends BattlePhase

class_name ExecutionBattlePhase

const BlockType = Enum.ExecutionBuildingBlockType

var _execution_instruction: ExecutionInstruction
var _execution_instruction_builder: ExecutionInstructionBuilder

func _init():
	name = "Execution"
	_name = "Execution"

func start(previous_phase_result: Dictionary = {}):
	super.start(previous_phase_result)
	
	_execution_instruction_builder = ExecutionInstructionBuilder.new()
	
	var command: Command = previous_phase_result.get("command")
	Assert.is_null_that_fails(command, "ERROR: No command for execution builder") 
	
	var recipe = command.get_execution_plan_duplicate()
	
	var actual_plan = ExecutionInstructionBuilder.build(recipe, previous_phase_result)

func exit():
	super.exit()
