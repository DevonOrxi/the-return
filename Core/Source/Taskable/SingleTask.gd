extends Taskable

class_name SingleTask

var _task: Callable

func _init(task: Callable):
	_task = task

func _work_tasks():
	await _task.call()
	_has_finished_all_tasks()

#var _tasks: Array[Taskable]
#signal finished
#
#func _init(tasks: Array[Taskable]):
	#_tasks = tasks
#
#func start():
	#if not is_node_ready():
		#await ready
	#
	#var finished_signals = _tasks.map(func(task: Taskable): return task.finished)
#
#func _has_finished_all_tasks():
	#finished.emit()
