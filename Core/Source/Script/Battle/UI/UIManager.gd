extends Control

class_name UIManager

const UIInstructionType = InstructionType.UI
const SelectionCursor = preload("res://Game/Source/Scene/UI/Panels/BattleSelectionCursor.tscn")

@onready var _debug_label = $Gradient/DebugLabel
@onready var _ui_animation_player = $UIAnimationPlayer
@onready var _action_panels = $ActionPanels
@onready var _movable_cursor: SelectionCursor = $Cursors/MovableCursor

signal start_animation_finished

var _focused_panel: UIActionPanel

func _ready():
	_ui_animation_player.animation_finished.connect(on_ui_animation_player_animation_finished)

func on_battle_director_debug_signal(text: String):
	_debug_label.text = text

func on_ui_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		start_animation_finished.emit()

# TODO: Change to Intro Phase
func on_battle_director_play_ui_animation(animation_name):
	_ui_animation_player.play(animation_name)

func on_battle_phase_manager_ui_change(instruction: UIInstructionType, payload: Dictionary):
	if instruction == null:
		push_warning("WARNING: No action for \"ui_change\"")
		return
	
	match instruction:
		UIInstructionType.DISABLE_ALL_ACTION_PANELS:
			_hide_all_action_panels()
		UIInstructionType.ENABLE_PANEL:
			_enable_action_panel(payload)
		UIInstructionType.MOVE_SELECTION_CURSOR_UI:
			_move_unique_cursor_to_ui(payload)
		_:
			pass

func _hide_all_action_panels():
	_action_panels\
		.get_children()\
		.all(\
			func disable(node: Control):\
				node.visible = false\
		)

func _enable_action_panel(payload: Dictionary):
	if not payload.has("enable_panel_target"):
		push_warning("WARNING: No target for \"enable_action_panel\"")
		return
	
	if not payload.has("panel_elements"):
		push_warning("WARNING: No panel elements for \"enable_action_panel\"")
		return
		
	var target = payload.get("enable_panel_target")
	
	var panel = _action_panels.find_child(target) as UIActionPanel
	if not panel:
		push_warning("WARNING: No target panel found for \"enable_action_panel\"")
		return
	
	var panel_payload = {
		"panel_elements" = payload.get("panel_elements")
	}
	
	panel.setup(panel_payload)
	panel.visible = true
	
	if payload.get("is_focus"):
		_focused_panel = panel

func _move_unique_cursor_to_ui(payload: Dictionary):
	
	var index = payload.get("cursor_ui_index") as int
	if index == null:
		push_warning("WARNING: No cursor index for \"_move_unique_cursor_to_ui\"")
		return
	
	var element = _focused_panel.elements.get_child(index) as Control
	
	if not _movable_cursor or not element:
		push_warning("WARNING: Invalid params for \"_move_unique_cursor_to_ui\"")
		return
	
	var is_flipped_x = payload.get("is_flipped_x", false)
	var is_animated = payload.get("is_animated", false)
	var x_dir = -1 if is_flipped_x else 1
	var cursor_position = element.global_position
	
	if element.has_method("get_cursor_anchor"):
		cursor_position = element.get_cursor_anchor()
	
	_movable_cursor.set_global_position(cursor_position)
	#_movable_cursor.set_flip_x(is_flipped_x)
	_movable_cursor.set_animated(is_animated)
	_movable_cursor.visible = true
