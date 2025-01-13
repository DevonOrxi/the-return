extends Node

var _logs: Array[String] = []
var _max_logs_shown: int = 4

signal logs_updated(logs: Array[String])

func push_log(log: String):
	_logs.append(log)
	
	var log_size = _logs.size()
	if not log_size:
		return
	
	var last_pos = maxi(0, log_size)
	var first_pos = maxi(0, last_pos - _max_logs_shown)
	var sliced_logs = _logs.duplicate().slice(first_pos, last_pos)
	logs_updated.emit(sliced_logs)
