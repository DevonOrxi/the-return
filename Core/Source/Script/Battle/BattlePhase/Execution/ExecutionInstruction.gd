class_name ExecutionInstruction

enum FinishCondition {
	DURATION,
	ANIMATION_FINISH
}

class ExecutionBuildingBlock:
	var next_instructions: Array[ExecutionBuildingBlock]
	var delay: float
	var duration: float
	var wait_after_finish: float
	var finish_condition: FinishCondition

class MoveBattlerBuildingBlock extends ExecutionBuildingBlock:
	var destination: Vector2
	var easing: Tween.EaseType
	var transition: Tween.TransitionType

class AnimateBattlerBuildingBlock extends ExecutionBuildingBlock:
	var animation_name: String
	var animation_looping: bool
	var animation_target: Battler

class FlashBattlerBuildingBlock extends ExecutionBuildingBlock:
	var flashing_target: Battler
	var flashing_color: Color

class ShowDamageBuildingBlock extends ExecutionBuildingBlock:
	var damage_text: String
	var damage_position: Vector2

var id: String
var instructions: Array[ExecutionBuildingBlock]
