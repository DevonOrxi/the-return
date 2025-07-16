extends BattlePhase

class_name ExecutionBattlePhase

const BlockType = Enum.BattleActionStepType

var _execution_instruction_builder: BattleActionSequenceBuilder

signal execution_command_ready(plan: BattleActionSequence)

func _init():
	name = "Execution"
	_name = "Execution"

func start(previous_phase_result: Dictionary = {}):
	super.start(previous_phase_result)
	
	_execution_instruction_builder = BattleActionSequenceBuilder.new()
	
	var command: Command = previous_phase_result.get("command")
	Assert.is_null_that_fails(command, "ERROR: No command for execution builder") 
	
	var blueprint = command.get_blueprint_duplicate()
	
	var actual_plan = BattleActionSequenceBuilder.build(blueprint, previous_phase_result)
	execution_command_ready.emit(actual_plan)

func exit():
	super.exit()
