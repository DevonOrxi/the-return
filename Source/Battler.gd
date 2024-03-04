extends Node2D

class_name Battler

class Stats:
	var speed: int
	
	func _init(p_speed: int = 0):
		speed = p_speed

var _stats: Stats
@onready var animatedSprite = $AnimatedSprite2D

func _init():
	_stats = Stats.new(randi_range(0, 9))

func get_speed_stat() -> int:
	print("speed: " + str(_stats.speed))
	return _stats.speed
