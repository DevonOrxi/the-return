extends Taskable

class_name ParallelTask

var _task_group: Array[Taskable]

func _init(task_group: Array[Taskable]):
	_task_group = task_group

func _work_tasks():
	for task in _task_group:
		task.start()
		await task.finished
	
	_has_finished_all_tasks()
