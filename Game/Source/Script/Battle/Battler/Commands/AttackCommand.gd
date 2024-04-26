extends Command

class_name AttackCommand

func _init():
	_name = "Attack"
	
	_steps.assign([CommandStepType.TARGET_ENEMY_SINGLE])
