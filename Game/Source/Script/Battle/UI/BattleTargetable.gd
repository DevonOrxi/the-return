extends Control

func get_cursor_anchor():
	var h_offset = size.y / 2
	return global_position + Vector2(-6, h_offset)
