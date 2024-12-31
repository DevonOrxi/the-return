extends Control

class_name DamageCounter

@onready var animation_player = $AnimationPlayer
@onready var damage_label = $DamageLabel
signal finished

func set_damage_label(with_text: String):
	damage_label.text = with_text

func _ready():
	animation_player.connect("animation_finished", _on_finished)
	animation_player.play("appear")

func _on_finished():
	finished.emit()
	queue_free()
