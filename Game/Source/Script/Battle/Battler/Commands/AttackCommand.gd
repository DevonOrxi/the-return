extends Command

class_name AttackCommand

func _init():
	_name = "Attack"
	_recipe_json = load("res://testyt.json")
	_steps.assign([CommandStepType.TARGET_ENEMY_SINGLE])
