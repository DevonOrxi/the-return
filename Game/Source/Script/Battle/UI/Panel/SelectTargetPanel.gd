extends UIActionPanel

const BattleTargetable = preload("res://Game/Source/Scene/UI/BattleTargetable.tscn")

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
	
	# TODO: REFACTOR POR DIOS
	for e in p_elements:
		var child_anchor = e.get_cursor_anchor()
		var child_name = e.get_battler_name()
		var child = BattleTargetable.instantiate()
		
		elements.add_child(child)
		
		call_deferred("_setup_child", child, child_name, child_anchor)

func _setup_child(child: Node, child_name: String, child_anchor: Vector2):
	child.name = child_name
	child.set_global_position(child_anchor)
