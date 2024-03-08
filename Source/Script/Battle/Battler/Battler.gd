extends Node2D

class_name Battler

var _stats: BattlerStats
@onready var animatedSprite = $AnimatedSprite2D

func _init():
	_stats = BattlerStats.new(randi_range(0, 9))

func get_speed_stat() -> int:
	return _stats.speed
