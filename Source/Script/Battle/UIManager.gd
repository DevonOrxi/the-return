extends Control

class_name UIManager

const UIInstructionType = InstructionType.UI
const SelectionCursor = preload("res://Source/Scene/BattleSelectionCursor.tscn")

@onready var _debug_label = $Gradient/DebugLabel
@onready var _ui_animation_player = $UIAnimationPlayer
@onready var _action_panels = $ActionPanels
@onready var _selection_cursors = $Cursors/SelectionCursors

signal start_animation_finished

var _focused_panel: UIActionPanel

func _ready():
	pass

func _process(_delta):
	pass

func _on_battle_manager_debug_signal(text: String):
	_debug_label.text = text

func _on_ui_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		start_animation_finished.emit()

# TODO: Change to Intro Phase
func _on_battle_director_play_ui_animation(animation_name):
	await ready
	_ui_animation_player.play(animation_name)

func _on_battle_phase_manager_ui_change(instruction: UIInstructionType, payload: Dictionary):

	if instruction == null:
		push_warning("WARNING: No action for \"ui_change\"")
		return
	
	match instruction:
		UIInstructionType.DISABLE_ALL_ACTION_PANELS:
			_hide_all_action_panels()
		UIInstructionType.ENABLE_PANEL:
			_enable_action_panel(payload)
		UIInstructionType.CLEAR_ALL_SELECTION_CURSORS:
			_clear_all_selection_cursors()
		UIInstructionType.SHOW_SELECTION_CURSORS_UI_ELEMENT:
			_show_selection_cursors_on_ui(payload)
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
	
	var target = payload["enable_panel_target"]
	
	var panel = _action_panels.find_child(target) as UIActionPanel
	if not panel:
		push_warning("WARNING: No target panel found for \"enable_action_panel\"")
		return
	
	var panel_payload = {}
	panel_payload["panel_elements"] = payload["panel_elements"]
	panel.setup(panel_payload)
	
	panel.visible = true
	_focused_panel = panel

func _show_selection_cursors_on_ui(payload: Dictionary):
	var cursor_element_indices = payload["cursor_element_indices"] as Array[int]
	
	if not cursor_element_indices:
		push_warning("WARNING: No cursor positions for \"show_selection_cursors\"")
		return
	
	for index in cursor_element_indices:
		var cursor = SelectionCursor.instantiate()
		var element = _focused_panel.elements.get_child(index) as Control
		
		if not cursor or not element:
			return
		
		var c_position = element.global_position + Vector2(-6, element.size.y / 2)
		
		cursor.set_global_position(c_position)
		_selection_cursors.add_child(cursor)

func _clear_all_selection_cursors():
	var children = _selection_cursors.get_children()
	for child in children:
		_selection_cursors.remove_child(child)
		child.queue_free()
