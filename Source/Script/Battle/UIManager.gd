extends Control

class_name UIManager

const UIInstructionType = InstructionType.UI

@onready var _debug_label = $Gradient/DebugLabel
@onready var _ui_animation_player = $UIAnimationPlayer
@onready var _action_panels = $ActionPanels

signal start_animation_finished

var _focused_panel: Control

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
			_disable_all_action_panels()
		UIInstructionType.ENABLE_PANEL:
			_enable_action_panel(payload)
		UIInstructionType.CLEAR_FOCUSED_PANEL:
			_clear_focused_panel()
		_:
			pass

func _disable_all_action_panels():
	_action_panels\
		.get_children()\
		.filter(func is_control(node): return node is Control)\
		.all(\
			func disable(node: Control):\
				node.visible = false\
		)

func _enable_action_panel(payload: Dictionary):
	var target = payload["enable_panel_target"]
	if not target:
		push_warning("WARNING: No target for \"enable_action_panel\"")
		return
	
	var panel = _action_panels.find_child(target) as Control
	if not panel:
		push_warning("WARNING: No target panel found for \"enable_action_panel\"")
		return
	
	panel.visible = true
	
	if payload["is_focus"]:
		_focused_panel = panel

func _clear_focused_panel():
	_focused_panel = null
