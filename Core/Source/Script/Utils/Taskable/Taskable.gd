class_name Taskable

signal finished

var _is_running = false

func start():
	if _is_running:
		push_warning("WARNING: Tried to start task twice")
	_work_tasks()

# Override this method in children
func _work_tasks():
	# Do NOT use this one
	pass

func _has_finished_all_tasks():
	finished.emit()
