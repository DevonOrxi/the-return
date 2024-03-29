
class_name Command

enum CommandStepType {
	SELECT_ACTOR,
	SELECT_BASE_ACTION,
	SELECT_ABILITY,
	TARGET_ENEMY_ALL,
	TARGET_ENEMY_SINGLE,
	TARGET_SELF,
	TARGET_ALLY_SINGLE,
	TARGET_ALLY_ALL,
	TARGET_ANY
}

class CommandStep:
	var _name: String
	var _type: CommandStepType
	
	func setup():
		pass
	
	func get_name() -> String:
		return _name

var _name: String
var _steps: Array[CommandStepType]




