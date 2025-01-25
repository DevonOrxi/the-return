extends Node2D

const jsoncito := preload("res://testyt.json")

func _ready() -> void:
	var data = jsoncito.data
	var builder = ExecutionInstructionBuilder.new()
	
	var instruction = builder.build(data, {})
	print(instruction.instructions[0].type)
