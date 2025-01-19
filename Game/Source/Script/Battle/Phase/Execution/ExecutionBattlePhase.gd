extends BattlePhase

class_name ExecutionBattlePhase

const BlockType = Enum.ExecutionBuildingBlockType

class ExecutionInstructionBuilder:
	static func build(recipe: Dictionary, input_values: Dictionary) -> ExecutionInstruction:
		var instructions = recipe.get("instructions") as Array
		if Assert.is_null_that_warns(instructions, "WARNING: No instructions for execution builder"):
			return null
		
		var id = recipe.get("id")
		var result = ExecutionInstruction.new()
		result.id = id
		result.instructions = _build_instruction_array(instructions, input_values.duplicate())
		
		return result
	
	static func _build_instruction_array(instructions: Array, input_values: Dictionary) -> Array[ExecutionBuildingBlock]:
		var result: Array[ExecutionBuildingBlock] = []
		
		for element in instructions:
			var instr_dict = element as Dictionary
			if Assert.is_null_that_warns(instr_dict, "WARNING: Invalid instruction for block building"):
				continue
			
			var block = _create_block(instr_dict, input_values.duplicate())
			if Assert.is_null(block):
				continue
			
			result.append(block)
			
			var next_instr_array = instr_dict.get("next_instructions")
			if not next_instr_array is Array:
				continue
			
			next_instr_array = next_instr_array as Array
			if Assert.is_null(next_instr_array):
				continue
			
			block.next_instructions = _build_instruction_array(next_instr_array, input_values.duplicate())
		
		return result
	
	static func _create_block(instruction: Dictionary, input_values: Dictionary) -> ExecutionBuildingBlock:
		var type = instruction.get("type")
		if Assert.is_null_that_warns(type, "WARNING: Could not find type for building block"):
			return null
		
		# crear dict 
		
		#match type:
			#_:
				#pass
		return null

var _execution_instruction: ExecutionInstruction
var _execution_instruction_builder := ExecutionInstructionBuilder.new()

func _init():
	name = "Execution"
	_name = "Execution"

func start(previous_phase_result: Dictionary = {}):
	super.start(previous_phase_result)
	
	var command: Command = previous_phase_result.get("command")
	Assert.is_null_that_fails(command, "ERROR: No command for execution builder") 
	
	var recipe = command.get_execution_plan_duplicate()
	
	var actual_plan = ExecutionInstructionBuilder.build(recipe, previous_phase_result)

func exit():
	super.exit()
