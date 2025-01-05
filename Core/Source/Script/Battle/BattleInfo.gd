class_name BattleInfo

var _actor: Battler
var _enemy_units: Array[Battler]
var _ally_units: Array[Battler]

func _init(actor: Battler, allies: Array[Battler], enemies: Array[Battler]):
	_actor = actor
	_ally_units = allies
	_enemy_units = enemies

func get_actor_commands() -> Array[Command]:
	return _actor.get_commands()
