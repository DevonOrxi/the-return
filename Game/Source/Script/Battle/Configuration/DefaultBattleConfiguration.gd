extends BattleConfiguration

class_name DefaultBattleConfiguration

func setup(phases_data: Dictionary):
	var intro = MockPhase.new()
	var planning: BattlePhase
	var execution = ExecutionBattlePhase.new()
	var outro = MockPhase.new()
	
	var actor = phases_data.get("actor", "")
	if actor is PlayerBattler:
		planning = PlanningBattlePhase.new()
	else:
		planning = NPCPlanningBattlePhase.new()
	
	intro.set_phase_name("Intro")
	intro.set_next_phase(planning)
	intro.setup(phases_data)
	
	planning.set_next_phase(execution)
	planning.setup(phases_data)
	
	execution.set_next_phase(outro)
	execution.execution_command_ready.connect(_on_phase_emitted_instructions)
	
	outro.set_phase_name("Outro")
	
	phases.assign([intro, planning, execution, outro])

func _on_phase_emitted_instructions(plan: ExecutionInstruction):
	instruction_emitted_by_phase.emit(plan)
