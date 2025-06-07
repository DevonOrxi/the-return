extends Command

class_name AttackCommand

func _init():
	_name = "Attack"
	_blueprint_json = load("res://testyt2.json")
	_steps.assign([CommandStepType.TARGET_ENEMY_SINGLE])
