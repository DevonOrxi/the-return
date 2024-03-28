extends Node2D

class_name Encounter

var _battle_director: BattleDirector
var _ui_manager: UIManager
var _battle_phase_manager: BattlePhaseManager

func _ready():
	setup()
	start()

func setup():
	# TODO: Instantiate scenes here
	_ui_manager = $CanvasLayer/UIManager
	_battle_director = $BattleDirector
	_battle_phase_manager = $BattleDirector/BattlePhaseManager
	
	var configuration = DefaultBattleConfiguration.new()
	
	#_ui_manager.setup()
	_battle_director.setup(configuration)
	
	_ui_manager.start_animation_finished.connect(_battle_director.on_ui_manager_start_animation_finished)
	_battle_director.play_ui_animation.connect(_ui_manager.on_battle_director_play_ui_animation)
	_battle_director.debug_signal.connect(_ui_manager.on_battle_director_debug_signal)
	_battle_phase_manager.ui_change.connect(_ui_manager.on_battle_phase_manager_ui_change)

func start():
	#_ui_manager.start()
	_battle_director.start()
