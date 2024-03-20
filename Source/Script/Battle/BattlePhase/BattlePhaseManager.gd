extends Node

class_name BattlePhaseManager

var _current_phase: BattlePhase
signal phase_changed(to_phase: BattlePhase)
signal update_phase()

func start_with_config(config: BattleConfiguration):
	for phase in config.phases:
		add_child(phase)
	
	_current_phase = config.phases[0]
	_current_phase.change_condition_met.connect(_change_phase)
	_current_phase.start()
	
	_change_phase(_current_phase)

func _change_phase(to_phase: BattlePhase):
	if _current_phase != null:
		if _current_phase.change_condition_met.is_connected(_change_phase):
			_current_phase.change_condition_met.disconnect(_change_phase)
		
		_current_phase.exit()
	
	_current_phase = to_phase
	_current_phase.change_condition_met.connect(_change_phase)
	_current_phase.start_with_params(null)
	
	phase_changed.emit(to_phase)
