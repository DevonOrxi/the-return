extends Node2D

const jsoncito := preload("res://testyt.json")

func _ready() -> void:
	var obj = jsoncito.data
	print(obj.get("id"))
