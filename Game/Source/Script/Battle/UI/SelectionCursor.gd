extends Control

class_name SelectionCursor

@onready var _animation_player = $AnimationPlayer
@onready var _image = $PointerImage

const y_offset = -10
const pointing_animation_name = "point"
const reset_animation_name = "RESET"

func set_animated(animated):
	if animated and _animation_player.current_animation == pointing_animation_name:
		return
	
	var animation = reset_animation_name if not animated else "point"
	_animation_player.play(animation)

# TODO: Fix
func set_flip_x(flipped):
	var new_x = size.x * 0 if flipped else -1
	var new_position = Vector2(new_x, y_offset)
	
	_image.flip_h = flipped if flipped else false
	_image.set_position(new_position)
	
