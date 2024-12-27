extends Node2D

class_name Battler

@onready var _cursor_anchor = $TargetIndictatorPosition

var _name: String
#var _stats: Dictionary
@export var _flipped_pointer: bool

func get_cursor_anchor() -> Vector2:
	return _cursor_anchor.global_position

func get_battler_name() -> String:
	return _name

func has_flipped_pointer() -> bool:
	return _flipped_pointer
