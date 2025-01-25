class_name ExecutionInstructionBuilder

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
		
		var block = _create_block(instr_dict.duplicate(), input_values.duplicate())
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
	
	var block: ExecutionBuildingBlock
	match type:
		"wait":
			block = WaitBuildingBlock.new()
		"move_battler":
			block = MoveBattlerBuildingBlock.new()
		"animate_battler":
			block = AnimateBattlerBuildingBlock.new()
		"flash_battler":
			block = FlashBattlerBuildingBlock.new()
		"damage_battler":
			block = ShowDamageBuildingBlock.new()
		_:
			pass
	
	# WARNING
	if Assert.is_null(block):
		return null
	
	block.set_values(instruction)
	# SET INPUT VALUES HERE
	
	return block
