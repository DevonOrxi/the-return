extends Node2D

var single_task: SingleTask

var first_task: SingleTask
var second_task: SingleTask

func _ready():
	_run_sequence_tasks()

func _run_single_task():
	single_task = SingleTask.new(func():
		print("ENTERED - SINGLE TASK")
		await get_tree().create_timer(5).timeout
		print("TIMEOUT - SINGLE TASK")
	)
	
	single_task.finished.connect(func():
		print("FINISHED - SINGLE TASK")
	)
	
	print("PRE-ENTER - SINGLE TASK")
	single_task.start()

func _run_sequence_tasks():
	second_task = SingleTask.new(func():
		print("ENTERED - SECOND TASK")
		await get_tree().create_timer(5).timeout
		print("TIMEOUT - SECOND TASK")
	)
	
	first_task = SingleTask.new(func():
		print("ENTERED - FIRST TASK")
		second_task.start()
		await second_task.finished
		print("TIMEOUT - FIRST TASK")
	)
	
	second_task.finished.connect(func():
		print("FINISHED - SECOND TASK")
	)
	
	first_task.finished.connect(func():
		print("FINISHED - FIRST TASK")
	)
	
	print("PRE-ENTER - FIRST TASK")
	first_task.start()
