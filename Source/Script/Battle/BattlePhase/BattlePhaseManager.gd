extends Node

class_name BattlePhaseManager

var _current_phase: BattlePhase
signal phase_changed(to_phase: BattlePhase)

func start():
	var phase = MockPhase.new()
	add_child(phase)
	_current_phase = phase
	phase.change_condition_met.connect(_change_phase)
	phase.start()
	_change_phase(_current_phase)

func _change_phase(to_phase: BattlePhase):
	_current_phase = to_phase
	phase_changed.emit(to_phase)
