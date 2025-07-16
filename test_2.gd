extends Node2D

const jsoncito := preload("res://testyt2.json")

func _ready() -> void:
	var data = jsoncito.data
	
	var instruction = BattleActionSequenceBuilder.build(data, {})
	print(instruction.sequence[0].type)
