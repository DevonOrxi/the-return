extends Node

class_name BattleDirector

@onready var _phase_manager = $BattlePhaseManager

signal debug_signal(text: String)
signal play_ui_animation(animation_name: String)

var _battle_configuration: BattleConfiguration
var _current_actor: Battler
var _turns: Array[Battler] = []

func setup(configuration: BattleConfiguration):
	_battle_configuration = configuration
	_phase_manager.phase_changed.connect(on_battle_phase_manager_phase_changed)
	_build_turn_order()

func start():
	# TODO: move to intro phase
	play_ui_animation.emit("intro")
	
	#_phase_manager.start()

func _build_turn_order():
	_turns = []
	var players: Array[Battler] = []
	var enemies: Array[Battler] = []
	
	players.assign($Battlers/Players.get_children())
	enemies.assign($Battlers/Enemies.get_children())
	
	_turns.append_array(players)
	_turns.append_array(enemies)

func on_ui_manager_start_animation_finished():
	# TODO: Move to setup
	
	_current_actor = _turns[0]
	
	var phase_data = {
		"actor" = _current_actor
	}
	
	_battle_configuration.setup(phase_data)
	_phase_manager.setup(_battle_configuration)
	_phase_manager.start()

func on_battle_phase_manager_phase_changed(to_phase: BattlePhase):
	if to_phase != null:
		debug_signal.emit(to_phase.get_phase_name())
