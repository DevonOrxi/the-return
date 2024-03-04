extends Control

@onready var debug_label = $Gradient/DebugLabel

func _ready():
	pass

func _process(delta):
	pass

func _on_battle_manager_debug_signal(text: String):
	debug_label.text = text
