class_name ExecutionBuildingBlock

enum FinishCondition {
	DURATION,
	ANIMATION_FINISH
}

var next_instructions: Array[ExecutionBuildingBlock]
var delay: float
var duration: float
var wait_after_finish: float
var finish_condition: FinishCondition
