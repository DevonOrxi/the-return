extends Command

class_name AttackCommand

func _init():
	_name = "Attack"
	
	_steps.assign([CommandStepType.TARGET_ENEMY_SINGLE])
	
	_execution_plan = {
		"sequence": [
			{
				"id": "move_actor",
				"actor": "ACTOR_REF",
				"pos": "POS_REF",
				"time_before": 0,
				"time": 2,
				"time_after": 0,
				"ease": "linear",
				
			}
		]
	}
