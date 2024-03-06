extends Node2D

class_name BattleManager

enum BattlePhase { INTRO, INFORMATION, PLANNING, ACTION, OUTRO }

var _current_actor: Battler
var _turns: Array[Battler] = []
var _current_phase: BattlePhase = BattlePhase.INTRO
signal debug_signal(text: String)

func _ready():
	_build_turn_order()
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	_run_current_phase()

func _build_turn_order():
	_turns = []
	var players: Array[Battler] = []
	var enemies: Array[Battler] = []
	
	players.assign($PlayerBattlers.get_children())
	enemies.assign($EnemyBattlers.get_children())
	
	_turns.append_array(players)
	_turns.append_array(enemies)
	_turns.sort_custom(_is_battler_speed_faster)

func _run_current_phase():
	debug_signal.emit(_phase_to_str(_current_phase) + " Phase")
	
	match _current_phase:
		BattlePhase.INTRO:
			_intro_phase()
		BattlePhase.INFORMATION:
			_information_phase()
		BattlePhase.PLANNING:
			_planning_phase()
		BattlePhase.ACTION:
			_action_phase()
		BattlePhase.OUTRO:
			_outro_phase()

func _intro_phase():
	# More logic here
	await get_tree().create_timer(1).timeout
	_set_battle_phase(BattlePhase.INFORMATION)

func _information_phase():
	pass

func _planning_phase():
	pass

func _action_phase():
	pass

func _outro_phase():
	pass

func _set_battle_phase(phase: BattlePhase):
	_current_phase = phase

func _is_battler_speed_faster(a: Battler, b: Battler) -> bool:
	return a.get_speed_stat() > b.get_speed_stat()

func _phase_to_str(phase: BattlePhase) -> String:
		match _current_phase:
			BattlePhase.INTRO:
				return "Intro"
			BattlePhase.INFORMATION:
				return "Information"
			BattlePhase.PLANNING:
				return "Planning"
			BattlePhase.ACTION:
				return "Action"
			BattlePhase.OUTRO:
				return "Outro"
			_:
				return "INVALID"
