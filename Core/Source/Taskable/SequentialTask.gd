extends Taskable

class_name SequentialTask

var _task: Callable
var _next_in_sequence: Taskable

func _init(task: Callable, next: Taskable = null):
	_task = task
	_next_in_sequence = next

func _work_tasks():
	if _next_in_sequence != null:
		_next_in_sequence.start()
		await _next_in_sequence.finished
	
	_task.call()
	_has_finished_all_tasks()
