extends UIActionPanel

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
		# TODO: Maybe add name?
		var child = Control.new()
		child.set_global_position(e)
		elements.add_child(child)
