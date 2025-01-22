class_name ExecutionBuildingBlock

enum FinishCondition {
	INSTANT,
	DURATION,
	ANIMATION_FINISH
}

var next_instructions: Array[ExecutionBuildingBlock]
var delay: float
var duration: float
var wait_after_finish: float
var finish_condition: FinishCondition

func set_values(dictionary: Dictionary):
	delay = dictionary.get("delay")
	duration = dictionary.get("duration")
	wait_after_finish = dictionary.get("wait_after_finish")
	
	var finish_condition_key = dictionary.get("finish_condition")
	finish_condition = _get_finish_condition(finish_condition_key)

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
