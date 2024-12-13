
class_name NavigationMap

var _elements: Dictionary

var looping: bool
var dimensions: Vector2
var pointer: Vector2 = Vector2.ZERO

func move_pointer_by(movement: Vector2):
	var result = pointer + movement
	
	# TODO: Check for empty positions
	if looping:
		result.x %= dimensions.x
		result.y %= dimensions.y
	else:
		result.x = clamp(result.x, 0, dimensions.x - 1)
		result.y = clamp(result.y, 0, dimensions.y - 1)
	
	pointer = result

func set_elements(element_grid: Dictionary):
	_elements = element_grid

func load_elements_from_array(array: Array):
	for i in array.size():
		var x = i % int(dimensions.x)
		var y = int(i / dimensions.x)
		_elements[Vector2(x, y)] = array[i]

func get_current_element():
	return _elements[pointer]

func get_elements() -> Array:
	return _elements.values()

func get_element_index() -> int:
	return int(pointer.y * dimensions.x + pointer.x)
