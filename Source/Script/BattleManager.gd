extends Node2D

class_name BattleManager

enum BattlePhase {
	BATTLE_START,
	PRE_ACTION,
	PLANNING,
	ACTION,
	POST_ACTION,
	BATTLE_END
}

var _current_actor: Battler
var _turns: Array[Battler] = []
var _current_phase: BattlePhase = BattlePhase.BATTLE_START
signal debug_signal(text: String)

var _mock_timer = 0

func _ready():
	_build_turn_order()
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	_mock_timer += delta
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
	debug_signal.emit(_phase_to_str() + " Phase")
	
	match _current_phase:
		BattlePhase.BATTLE_START:
			_battle_start_phase()
		BattlePhase.PRE_ACTION:
			_pre_action_phase()
		BattlePhase.PLANNING:
			_planning_phase()
		BattlePhase.ACTION:
			_action_phase()
		BattlePhase.POST_ACTION:
			_post_action_phase()
		BattlePhase.BATTLE_END:
			_battle_end_phase()

func _battle_start_phase():
	if _mock_timer >= 1:
		_finished_phase()

func _pre_action_phase():
	if _mock_timer >= 1:
		_finished_phase()

func _planning_phase():
	if _mock_timer >= 1:
		_finished_phase()

func _action_phase():
	if _mock_timer >= 1:
		_finished_phase()

func _post_action_phase():
	if _mock_timer >= 1:
		_finished_phase()

func _battle_end_phase():
	if _mock_timer >= 1:
		_finished_phase()

func _finished_phase():
	match _current_phase:
		BattlePhase.BATTLE_START:
			_set_battle_phase(BattlePhase.PRE_ACTION)
		BattlePhase.PRE_ACTION:
			_set_battle_phase(BattlePhase.PLANNING)
		BattlePhase.PLANNING:
			_set_battle_phase(BattlePhase.ACTION)
		BattlePhase.ACTION:
			_set_battle_phase(BattlePhase.POST_ACTION)
		BattlePhase.POST_ACTION:
			_set_battle_phase(BattlePhase.PRE_ACTION)
		BattlePhase.BATTLE_END:
			pass
	
	_mock_timer = 0

func _set_battle_phase(phase: BattlePhase):
	_current_phase = phase

func _is_battler_speed_faster(a: Battler, b: Battler) -> bool:
	return a.get_speed_stat() > b.get_speed_stat()

func _phase_to_str() -> String:
		match _current_phase:
			BattlePhase.BATTLE_START:
				return "Intro"
			BattlePhase.PRE_ACTION:
				return "Pre-action"
			BattlePhase.PLANNING:
				return "Planning"
			BattlePhase.ACTION:
				return "Action"
			BattlePhase.POST_ACTION:
				return "Post-action"
			BattlePhase.BATTLE_END:
				return "Outro"
			_:
				return "INVALID"
