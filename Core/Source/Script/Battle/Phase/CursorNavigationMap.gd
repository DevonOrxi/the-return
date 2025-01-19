
class_name CursorNavigationMap

var _elements: Dictionary

var _looping: bool
var _pointer: Vector2 = Vector2.ZERO
var _dimensions: Vector2

func move_pointer_by(movement: Vector2):
	var result = _pointer + movement
	
	# TODO: Check for empty positions
	if _looping:
		result.x = int(result.x) % int(_dimensions.x)
		result.y = int(result.y) % int(_dimensions.y)
	else:
		result.x = clamp(result.x, 0, _dimensions.x - 1)
		result.y = clamp(result.y, 0, _dimensions.y - 1)
	
	_pointer = result

#func set_elements(element_grid: Dictionary):
	#_elements = element_grid

func load_elements_from_array(array: Array):
	for i in array.size():
		var x = i % int(_dimensions.x)
		var y = int(i / _dimensions.x)
		_elements[Vector2(x, y)] = array[i]

func get_current_element():
	return _elements[_pointer]

func get_elements() -> Array:
	return _elements.values()

func get_current_element_index() -> int:
	return int(_pointer.y * _dimensions.x + _pointer.x)

func get_dimensions() -> Vector2:
	return _dimensions

func get_pointer() -> Vector2:
	return _pointer
	
func get_is_looping_map() -> bool:
	return _looping

func set_pointer(value: Vector2):
	_pointer = value
	
func set_is_looping_map(value: bool):
	_looping = value

func set_dimensions(value: Vector2):
	_dimensions = value
