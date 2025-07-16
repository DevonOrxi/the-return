extends BattleActionStep

class_name MoveBattlerActionStep

var destination: Vector2
var easing: Tween.EaseType
var transition: Tween.TransitionType

func set_command_config_values(dictionary: Dictionary):
	super.set_command_config_values(dictionary)
	
	var dest_x = dictionary.get("destination_x", 0.0)
	var dest_y = dictionary.get("destination_y", 0.0)
	destination = Vector2(dest_x, dest_y)
	
	var easing_key: String = dictionary.get("easing", "")
	easing = _easing_string_to_enum(easing_key)
	
	var transition_key: String = dictionary.get("transition", "")
	transition = _transition_string_to_enum(transition_key)

# TODO: Extract
func _easing_string_to_enum(key: String) -> Tween.EaseType:
	match key:
		"ease_out":
			return Tween.EaseType.EASE_OUT
		"ease_in":
			return Tween.EaseType.EASE_IN
		"ease_in_out":
			return Tween.EaseType.EASE_IN_OUT
		"ease_out_in":
			return Tween.EaseType.EASE_OUT_IN
		_:
			return Tween.EaseType.EASE_IN_OUT

func _transition_string_to_enum(key: String) -> Tween.TransitionType:
	match key:
		"trans_back":
			return Tween.TransitionType.TRANS_BACK
		"trans_bounce":
			return Tween.TransitionType.TRANS_BOUNCE
		"trans_circ":
			return Tween.TransitionType.TRANS_CIRC
		"trans_cubic":
			return Tween.TransitionType.TRANS_CUBIC
		"trans_elastic":
			return Tween.TransitionType.TRANS_ELASTIC
		"trans_expo":
			return Tween.TransitionType.TRANS_EXPO
		"trans_linear":
			return Tween.TransitionType.TRANS_LINEAR
		"trans_quad":
			return Tween.TransitionType.TRANS_QUAD
		"trans_quart":
			return Tween.TransitionType.TRANS_QUART
		"trans_quint":
			return Tween.TransitionType.TRANS_QUINT
		"trans_sine":
			return Tween.TransitionType.TRANS_SINE
		"trans_spring":
			return Tween.TransitionType.TRANS_SPRING
		_:
			return Tween.TransitionType.TRANS_LINEAR
