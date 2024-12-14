extends UIActionPanel

const Targetable = preload("res://Game/Source/Scene/UI/BattleTargetable.tscn")

func _ready():
	elements = $Elements

func setup(payload: Dictionary):
	for n in elements.get_children():
		elements.remove_child(n)
		n.queue_free() 
	
	var p_elements = payload["panel_elements"] as Array[Battler]
	if not p_elements:
		push_warning("WARNING: No elements for SelectTargetPanel")
		return
	
	for e in p_elements:
		var child = Targetable.instantiate()
		var position = e.global_position
		var anchor = e.get_cursor_anchor()
		child.name = e.get_battler_name()
		child.set_global_position(anchor)
		elements.add_child(child)
