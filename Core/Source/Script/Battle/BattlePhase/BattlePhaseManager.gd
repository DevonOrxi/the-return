extends Node

class_name BattlePhaseManager

const UIInstructionType = InstructionType.UI

var _current_phase: BattlePhase
signal phase_changed(to_phase: BattlePhase)
signal turn_ended()
signal ui_change(instruction: UIInstructionType, payload: Dictionary)

func setup(config: BattleConfiguration):
	for phase in config.phases:
		add_child(phase)

func start():
	_change_phase(get_child(0), {})
	_current_phase.start()

func _change_phase(to_phase: BattlePhase, payload: Dictionary):
	if _current_phase != null:
		_current_phase.change_condition_met.disconnect(_change_phase)
		_current_phase.ui_change.disconnect(_ui_change)
		_current_phase.exit()
	
	if to_phase == null:
		turn_ended.emit()
	else:
		_current_phase = to_phase
		_current_phase.change_condition_met.connect(_change_phase)
		_current_phase.ui_change.connect(_ui_change)
		_current_phase.start(payload)
		
		## Abajo?
		phase_changed.emit(to_phase)
	

func _ui_change(instruction: UIInstructionType, payload: Dictionary):
	ui_change.emit(instruction, payload)

func clean():
	_current_phase = null
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
