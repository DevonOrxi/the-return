
class_name NavigationMap

var _elements: Dictionary

var looping: bool
var pointer: Vector2 = Vector2.ZERO
var _dimensions: Vector2

func _init(dimensions: Vector2):
	_dimensions = dimensions

func move_pointer_by(movement: Vector2):
	var result = pointer + movement
	
	# TODO: Check for empty positions
	if looping:
		result.x %= _dimensions.x
		result.y %= _dimensions.y
	else:
		result.x = clamp(result.x, 0, _dimensions.x - 1)
		result.y = clamp(result.y, 0, _dimensions.y - 1)
	
	pointer = result

#func set_elements(element_grid: Dictionary):
	#_elements = element_grid

func load_elements_from_array(array: Array):
	for i in array.size():
		var x = i % int(_dimensions.x)
		var y = int(i / _dimensions.x)
		_elements[Vector2(x, y)] = array[i]

func get_current_element():
	return _elements[pointer]

func get_elements() -> Array:
	return _elements.values()

func get_current_element_index() -> int:
	return int(pointer.y * _dimensions.x + pointer.x)

func get_dimensions() -> Vector2:
	return _dimensions
