extends Node

class_name BattleDirector

@onready var _phase_manager = $BattlePhaseManager

var _current_actor: Battler
var _turns: Array[Battler] = []
signal debug_signal(text: String)
signal play_ui_animation(animation_name: String)

func _ready():
	play_ui_animation.emit("intro")
	_build_turn_order()

func _process(_delta):
	pass

func _build_turn_order():
	_turns = []
	var players: Array[Battler] = []
	var enemies: Array[Battler] = []
	
	players.assign($Battlers/Players.get_children())
	enemies.assign($Battlers/Enemies.get_children())
	
	_turns.append_array(players)
	_turns.append_array(enemies)
	_turns.sort_custom(_is_battler_speed_faster)
	
func _is_battler_speed_faster(a: Battler, b: Battler) -> bool:
	return a.get_speed_stat() > b.get_speed_stat()

func _on_ui_manager_start_animation_finished():
	_phase_manager.start()

func _on_battle_phase_manager_phase_changed(to_phase: BattlePhase):
	if to_phase != null:
		debug_signal.emit(to_phase.get_phase_name())
