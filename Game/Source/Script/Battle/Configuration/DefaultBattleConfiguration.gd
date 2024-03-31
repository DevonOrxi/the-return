extends BattleConfiguration

class_name DefaultBattleConfiguration
	
func setup(phases_data: Dictionary):
	var intro = MockPhase.new()
	var planning = PlanningBattlePhase.new()
	var execution = MockPhase.new()
	var outro = MockPhase.new()
	
	intro.set_phase_name("Intro")
	intro.next_phase = planning
	
	planning.setup(phases_data)
	planning.set_next_phase(execution)
	
	execution.set_phase_name("Execution")
	execution.next_phase = planning
	
	outro.set_phase_name("Outro")
	
	phases.assign([intro, planning, execution, outro])
