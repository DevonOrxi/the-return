extends Taskable

class_name SingleTask

var _task: Callable

func _init(task: Callable):
	_task = task

func _work_tasks():
	await _task.call()
	_has_finished_all_tasks()
