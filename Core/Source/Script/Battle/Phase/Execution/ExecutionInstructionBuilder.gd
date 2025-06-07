class_name ExecutionInstructionBuilder

static func build(blueprint: Dictionary, state_params: Dictionary) -> ExecutionInstruction:
	var instructions = blueprint.get("instructions") as Array
	var sequence = blueprint.get("sequence") as Array
	
	if Assert.is_null_that_warns(instructions, "WARNING: No instructions for execution builder"):
		return null
		
	if Assert.is_null_that_warns(sequence, "WARNING: No sequence for execution builder"):
		return null
	
	var id = blueprint.get("id")
	var result = ExecutionInstruction.new()
	var instruction_map = _map_instruction_dict(instructions, state_params.duplicate())
	var full_sequence = _create_instruction_sequence(sequence, instruction_map)
	
	result.id = id
	result.instructions = full_sequence
	return result

static func _map_instruction_dict(instructions: Array, state_params: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	
	for instr in instructions:
		var instr_dict = instr as Dictionary
		var instr_id = instr_dict["id"] as String
		
		if Assert.is_null_that_warns(instr_dict, "WARNING: Invalid instruction for mapping"):
			continue
			
		if Assert.is_null_that_warns(instr_id, "WARNING: Invalid id for instruction mapping"):
			continue
		
		instr_dict["state_params"] = state_params
		
		result[instr_id] = instr_dict
	return result

static func _create_instruction_sequence(id_sequence: Array, instructions: Dictionary) -> Array[ExecutionBuildingBlock]:
	var result: Array[ExecutionBuildingBlock] = []
	
	for step in id_sequence:
		var step_dict = step as Dictionary
		
		# TODO: Clean warnings
		if Assert.is_null_that_warns(step_dict, "WARNING: Invalid sequence for block building"):
			return []
		
		var id = step_dict.get("id")
		if Assert.is_null_that_warns(id, "WARNING: Invalid step id for sequence building"):
			return []
		
		var instruction = instructions.get(id)
		if Assert.is_null_that_warns(instruction, "WARNING: No instruction with matching id" + id):
			return []
		
		var block = _create_block(instruction.duplicate(true))
		if Assert.is_null_that_warns(block, "WARNING: Invalid instruction block"):
			return []
		
		result.append(block)
		
		var next = step_dict.get("next")
		if next is Array:
			block.next_instructions = _create_instruction_sequence(next, instructions)
	
	return result

static func _create_block(instruction: Dictionary) -> ExecutionBuildingBlock:
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
	
	block.set_command_config_values(instruction)
	
	return block
