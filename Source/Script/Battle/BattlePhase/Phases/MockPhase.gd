extends BattlePhase

class_name MockPhase

class MockCondition extends BattlePhaseChangeCondition:
	
	var evaluate_callable: Callable
	
	func evaluate() -> bool:
		return evaluate_callable.call()

var mockTimer = 0

func _init():
	super._init()
	
	var condition = MockCondition.new()
	condition.evaluate_callable = _is_timer_up
	_change_conditions = [condition]
	name = "Mock Phase"
	_name = "Mock Phase"

func _process(delta):
	super._process(delta)
	
	if not _is_timer_up():
		mockTimer += delta

func _is_timer_up() -> bool:
	return mockTimer >= 1
