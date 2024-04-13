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
	
	var animation = reset_animation_name if not animated else pointing_animation_name
	_animation_player.play(animation)

func set_flip_x(flipped):
	var image_width = _image.size.x
	var new_x = 0
	
	if not flipped:
		new_x = -_image.size.x
	
	_image.flip_h = flipped if flipped else false

func get_image_size() -> Vector2:
	return _image.size
