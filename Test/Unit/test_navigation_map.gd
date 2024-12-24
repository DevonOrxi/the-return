extends GutTest

var nav_map: NavigationMap

const DEFAULT_DIMENSIONS = Vector2(3, 3)

func test_init():
	_given_a_nav_map()
	_then_all_is_default()

func test_dimensions():
	_given_a_nav_map(DEFAULT_DIMENSIONS)
	_then_dimensions_are(DEFAULT_DIMENSIONS)

func test_element_load_thru_fitting_array():
	_given_a_nav_map(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	_when_loading_elements_from_array(element_array)
	
	_then_nav_map_elements_are(element_array)

func test_element_load_thru_not_fitting_array():
	_given_a_nav_map(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	element_array.append("OVERFLOW")
	_when_loading_elements_from_array(element_array)
	
	_then_nav_map_elements_are(element_array)

func test_element_load_thru_smaller_array():
	_given_a_nav_map(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	element_array.resize(element_array.size() - 1)
	_when_loading_elements_from_array(element_array)
	
	_then_nav_map_elements_are(element_array)

func test_get_current_element():
	_given_a_nav_map(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	_when_loading_elements_from_array(element_array)
	
	_then_element_at_pointer_is("(0, 0)")

func test_get_current_element_index():
	_given_a_nav_map(DEFAULT_DIMENSIONS)
	
	var element_array = _generate_element_array_from_dimensions(DEFAULT_DIMENSIONS)
	_when_loading_elements_from_array(element_array)
	
	_then_index_at_pointer_is(0)

func _given_a_nav_map(dimensions: Vector2 = Vector2(0, 0)):
	nav_map = NavigationMap.new(dimensions)

func _when_loading_elements_from_array(elements: Array):
	nav_map.load_elements_from_array(elements)

func _then_all_is_default():
	_then_dimensions_are(Vector2.ZERO)
	_then_nav_map_elements_are([])
	assert_eq(nav_map.looping, false)
	assert_eq(nav_map.pointer, Vector2.ZERO)
	
func _then_dimensions_are(dimensions: Vector2):
	assert_eq(nav_map.get_dimensions(), dimensions)

func _then_nav_map_elements_are(elements: Array):
	assert_eq(nav_map.get_elements(), elements)

func _then_element_at_pointer_is(element: Variant):
	assert_eq(nav_map.get_current_element(), element)

func _then_index_at_pointer_is(index: int):
	assert_eq(nav_map.get_current_element_index(), index)

func _generate_element_array_from_dimensions(dimensions: Vector2) -> Array:
	var array: Array[String]
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			var element = _string_for_position(i, j)
			array.append(element)
	return array

func _string_for_position(x: int, y: int) -> String:
	return "(" + str(x) + ", " + str(y) + ")"
