extends Control

class_name DebugLoggable

const LogLabel = preload("res://Game/Assets/UI/LogLabel.tscn")

func _ready():
	DebugLog.logs_updated.connect(_did_recieve_logs)

func _did_recieve_logs(logs: Array[String]):
	for c in get_children():
		remove_child(c)
		c.queue_free()
	
	for l in logs:
		var label = _get_label(l)
		add_child(label)

func _get_label(text: String) -> Label:
	var label = LogLabel.instantiate()
	label.text = text
	return label

func log():
	DebugLog.push_log("ATTACKED!!!")
