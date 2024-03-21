extends Node

class_name BattlePhaseManager

const UIInstructionType = InstructionType.UI

var _current_phase: BattlePhase
signal phase_changed(to_phase: BattlePhase)
signal ui_change(instruction: UIInstructionType, payload: Dictionary)

func start_with_config(config: BattleConfiguration):
	for phase in config.phases:
		add_child(phase)
	
	_current_phase = config.phases[0]
	_current_phase.change_condition_met.connect(_change_phase)
	_current_phase.start()
	
	_current_phase.ui_change.connect(_ui_change)
	
	_change_phase(_current_phase)

func _change_phase(to_phase: BattlePhase):
	if _current_phase != null:
		_current_phase.change_condition_met.disconnect(_change_phase)
		_current_phase.ui_change.disconnect(_ui_change)
		
		_current_phase.exit()
	
	_current_phase = to_phase
	_current_phase.change_condition_met.connect(_change_phase)
	_current_phase.ui_change.connect(_ui_change)
	_current_phase.start_with_params(null)
	
	phase_changed.emit(to_phase)

func _ui_change(instruction: UIInstructionType, payload: Dictionary):
	ui_change.emit(instruction, payload)
