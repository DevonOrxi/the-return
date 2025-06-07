extends Node2D

const jsoncito := preload("res://testyt2.json")

func _ready() -> void:
	var data = jsoncito.data
	
	var instruction = ExecutionInstructionBuilder.build(data, {})
	print(instruction.instructions[0].type)
