extends Control

class_name UIManager

@onready var _debug_label = $Gradient/DebugLabel
@onready var _ui_animation_player = $UIAnimationPlayer

signal start_animation_finished

func _ready():
	pass

func _process(_delta):
	pass

func _on_battle_manager_debug_signal(text: String):
	_debug_label.text = text

func _on_ui_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		start_animation_finished.emit()

func _on_battle_director_play_ui_animation(animation_name):
	await ready
	_ui_animation_player.play(animation_name)
