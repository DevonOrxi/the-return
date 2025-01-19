class_name Assert

const _default_null_message := "unexpected null value encountered"

# TODO: Every null_failing should be a null_with_warning, save it!
static func is_null_that_fails(value: Variant, custom_message: String = "") -> bool:
	return _check(value, true, false, true, custom_message)

static func is_null_that_warns(value: Variant, custom_message: String = "") -> bool:
	return _check(value, false, false, true, custom_message)

static func is_nullempty_that_warns(value: Variant, custom_message: String = "") -> bool:
	return _check(value, false, true, true, custom_message)

static func is_null(value: Variant) -> bool:
	return _check(value, false, false, false)

static func is_nullempty(value: Variant) -> bool:
	return _check(value, false, true, false)

static func _check(value: Variant, should_fail: bool, should_check_empty: bool, should_print: bool, custom_message: String = "") -> bool:
	var prefix = "ERROR: " if should_fail else "WARNING: "
	var message = custom_message if not custom_message.is_empty() else prefix + _default_null_message
	
	if value == null:
		_print(message, should_fail)
		return true
	elif value is Array:
		if should_check_empty and value.size() == 0:
			return true
		for e in value:
			if e == null:
				_print(message, should_fail)
				return true
	return false

static func _print(message: String, is_error: bool):
	if is_error:
		push_error(message)
	else:
		push_warning(message)
