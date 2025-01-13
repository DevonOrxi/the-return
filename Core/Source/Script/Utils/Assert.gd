class_name Assert

const _default_null_message := "unexpected null value encountered"

# TODO: Every null_failing should be a null_with_warning, save it!
static func is_null_that_fails(value: Variant, custom_message: String = ""):
	if value == null:
		push_error(custom_message if custom_message else "ERROR: " + _default_null_message)
	elif value is Array:
		for e in value:
			if e == null:
				push_error(custom_message if custom_message else "ERROR: " + _default_null_message)
	return

static func is_null_that_warns(value: Variant, custom_message: String = "") -> bool:
	if value == null:
		push_warning(custom_message if custom_message else "WARNING: " + _default_null_message)
		return true
	elif value is Array:
		for e in value:
			if e == null:
				push_warning(custom_message if custom_message else "WARNING: " + _default_null_message)
				return true
	return false
