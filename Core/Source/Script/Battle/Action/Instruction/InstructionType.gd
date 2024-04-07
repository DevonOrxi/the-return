extends Node

# TODO: Convert into Dictionary? Generic in core?
enum UI {
	DISABLE_ALL_ACTION_PANELS,
	ENABLE_PANEL,
	SHOW_SELECTION_CURSORS_UI_ELEMENT,
	CLEAR_ALL_SELECTION_CURSORS,
	SHOW_ACTOR_POINTER,
	CLEAR_ALL_ACTOR_POINTERS,
}

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
