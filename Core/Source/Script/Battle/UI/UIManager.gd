extends Control

class_name UIManager

const UIOrderType = Enum.UIOrderType

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
		#Se ejecuta dos veces?
		_ui_animation_player.animation_finished.disconnect(on_ui_animation_player_animation_finished)
		start_animation_finished.emit()

# TODO: Change to Intro Phase
func on_battle_director_play_ui_animation(animation_name):
	_ui_animation_player.play(animation_name)

func on_battle_phase_manager_ui_change(instruction: UIOrderType, payload: Dictionary):
	if instruction == null:
		push_warning("WARNING: No action for \"ui_change\"")
		return
	
	match instruction:
		UIOrderType.DISABLE_ALL_ACTION_PANELS:
			_hide_all_action_panels()
		UIOrderType.ENABLE_PANEL:
			_enable_action_panel(payload)
		UIOrderType.MOVE_SELECTION_CURSOR_UI:
			call_deferred("_move_unique_cursor_to_ui", payload)
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
	
	# TODO: Await?
	panel.setup(panel_payload)
	panel.visible = true
	
	if payload.get("is_focus"):
		_focused_panel = panel

func _move_unique_cursor_to_ui(payload: Dictionary):
	if not _movable_cursor:
		push_warning("WARNING: No cursor for \"_move_unique_cursor_to_ui\"")
		return
	
	var index = payload.get("cursor_ui_index") as int
	if index == null:
		push_warning("WARNING: No cursor index for \"_move_unique_cursor_to_ui\"")
		return
	
	var element = _focused_panel.elements.get_child(index) as Control
	if not element:
		push_warning("WARNING: Invalid params for \"_move_unique_cursor_to_ui\"")
		return
	
	if not element.is_node_ready():
		push_warning("WARNING: Element not ready for \"_move_unique_cursor_to_ui\"")
		return
	
	var is_flipped_x = payload.get("is_flipped_x", false)
	var is_animated = payload.get("is_animated", false)
	var cursor_position = element.global_position
	
	if element.has_method("get_cursor_anchor"):
		cursor_position = element.get_cursor_anchor()
	else:
		push_warning("MAYBE WARNING?: No anchor for cursor")
	
	if is_flipped_x:
		cursor_position.x += _movable_cursor.get_image_size().x
	
	_movable_cursor.set_global_position(cursor_position)
	_movable_cursor.set_flip_x(is_flipped_x)
	_movable_cursor.set_animated(is_animated)
	_movable_cursor.visible = true
