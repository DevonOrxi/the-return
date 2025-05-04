class_name ExecutionBuildingBlock

enum FinishCondition {
	INSTANT,
	DURATION,
	ANIMATION_FINISH
}

var type: String
var next_instructions: Array[ExecutionBuildingBlock]
var delay: float
var duration: float
var wait_after_finish: float
var finish_condition: FinishCondition

func set_command_config_values(dictionary: Dictionary):
	type = dictionary.get("type", "")
	delay = dictionary.get("delay", 0.0)
	duration = dictionary.get("duration", 0.0)
	wait_after_finish = dictionary.get("wait_after_finish", 0.0)
	
	var finish_condition_key = dictionary.get("finish_condition", "")
	finish_condition = _get_finish_condition(finish_condition_key)

@warning_ignore("unused_parameter")
func set_player_input_values(dictionary: Dictionary):
	pass

func _get_finish_condition(key: String) -> FinishCondition:
	match key:
		"instant":
			return FinishCondition.INSTANT
		"duration":
			return FinishCondition.DURATION
		"animation_finish":
			return FinishCondition.ANIMATION_FINISH
		_:
			Assert.is_null_that_warns(key, "WARNING: Invalid key for block finish condition")
	
	return FinishCondition.INSTANT
