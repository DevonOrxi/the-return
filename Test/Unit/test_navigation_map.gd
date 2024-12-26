extends GutTest

var nav_map: NavigationMap

const DEFAULT_DIMENSIONS = Vector2(3, 3)
const CUSTOM_POINTER = Vector2(1, 1)

#region Tests
func test_init():
	_given_a_nav_map_with_size()
	_then_all_is_default()

func test_dimensions():
	_given_a_nav_map_with_size(DEFAULT_DIMENSIONS)
	_then_dimensions_are(DEFAULT_DIMENSIONS)

func test_element_load_thru_fitting_array():
	_given_a_nav_map_with_size(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	_when_loading_elements_from_array(element_array)
	
	_then_nav_map_elements_are(element_array)

func test_element_load_thru_not_fitting_array():
	_given_a_nav_map_with_size(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	element_array.append("OVERFLOW")
	_when_loading_elements_from_array(element_array)
	
	_then_nav_map_elements_are(element_array)

func test_element_load_thru_smaller_array():
	_given_a_nav_map_with_size(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	element_array.resize(element_array.size() - 1)
	_when_loading_elements_from_array(element_array)
	
	_then_nav_map_elements_are(element_array)

func test_get_current_element():
	_given_a_nav_map_with_size(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	_when_loading_elements_from_array(element_array)
	_when_pointer_is(CUSTOM_POINTER)
	
	_then_element_at_pointer_is("(1, 1)")

func test_get_current_element_index():
	_given_a_nav_map_with_size(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	_when_loading_elements_from_array(element_array)
	_when_pointer_is(CUSTOM_POINTER)
	
	_then_index_at_pointer_is(4)

func test_input_regular():
	_given_a_nav_map_with_size(Vector2(3, 3))
	
	_when_pointer_is(Vector2(1,1))
	_when_moving_pointer_by(Vector2(1, 0))
	
	_then_pointer_is(Vector2(2, 1))

func test_input_oob_non_looping():
	_given_a_nav_map_with_size(Vector2(3, 3))
	
	_when_looping_is(false)
	_when_pointer_is(Vector2(2,1))
	_when_moving_pointer_by(Vector2(1, 0))
	
	_then_pointer_is(Vector2(2, 1))

func test_input_oob_looping():
	_given_a_nav_map_with_size(Vector2(3, 3))
	
	_when_looping_is(true)
	_when_pointer_is(Vector2(2,1))
	_when_moving_pointer_by(Vector2(1, 0))
	
	_then_pointer_is(Vector2(0, 1))
#endregion

#region Given
func _given_a_nav_map_with_size(dimensions: Vector2 = Vector2(0, 0)):
	nav_map = NavigationMap.new(dimensions)
#endregion

#region When
func _when_loading_elements_from_array(elements: Array):
	nav_map.load_elements_from_array(elements)

func _when_pointer_is(pointer: Vector2):
	nav_map.set_pointer(pointer)

func _when_moving_pointer_by(delta_pos: Vector2):
	nav_map.move_pointer_by(delta_pos)

func _when_looping_is(value: bool):
	nav_map.set_is_looping_map(value)
#endregion

#region Then
func _then_all_is_default():
	_then_dimensions_are(Vector2.ZERO)
	_then_nav_map_elements_are([])
	assert_eq(nav_map.get_is_looping_map(), false)
	assert_eq(nav_map.get_pointer(), Vector2.ZERO)
	
func _then_dimensions_are(dimensions: Vector2):
	assert_eq(nav_map.get_dimensions(), dimensions)

func _then_nav_map_elements_are(elements: Array):
	assert_eq(nav_map.get_elements(), elements)

func _then_element_at_pointer_is(element: Variant):
	assert_eq(nav_map.get_current_element(), element)

func _then_index_at_pointer_is(index: int):
	assert_eq(nav_map.get_current_element_index(), index)

func _then_pointer_is(pointer: Vector2):
	assert_eq(nav_map.get_pointer(), pointer)
#endregion

#region Helper functions
func _generate_element_array_from_dimensions(dimensions: Vector2) -> Array:
	var array: Array[String]
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			var element = _string_for_position(i, j)
			array.append(element)
	return array

func _string_for_position(x: int, y: int) -> String:
	return "(" + str(x) + ", " + str(y) + ")"
#endregion
