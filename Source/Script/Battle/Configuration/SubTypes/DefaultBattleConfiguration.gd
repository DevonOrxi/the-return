extends BattleConfiguration

class_name DefaultBattleConfiguration
	
func setup_with(actor: Battler):
	var intro = MockPhase.new()
	var planning = PlanningBattlePhase.new()
	var execution = MockPhase.new()
	var outro = MockPhase.new()
	
	intro.set_phase_name("Intro")
	intro.next_phase = planning
	
	planning.set_actor(actor)
	planning.next_phase = execution
	
	execution.set_phase_name("Execution")
	execution.next_phase = planning
	
	outro.set_phase_name("Outro")
	
	phases.assign([intro, planning, execution, outro])
