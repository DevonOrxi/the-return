extends Node

@onready var _battle_director = $BattleDirector
@onready var _ui_manager = $UIManager

func _ready():
	_ui_manager.play_ui_animation("intro")

func _on_ui_manager_start_animation_finished():
	_battle_director.process_mode = Node.PROCESS_MODE_PAUSABLE
