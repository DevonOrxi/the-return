extends UIActionPanel

const BattleLabel = preload("res://Game/Source/Scene/BattleBasicLabel.tscn")

func setup(payload: Dictionary):
	for n in elements.get_children():
		elements.remove_child(n)
		n.queue_free() 
	
	var p_elements = payload["panel_elements"] as Array[String]
	if not p_elements:
		push_warning("WARNING: No elements for BaseActionPanel")
		return
	
	for e in p_elements:
		var child = BattleLabel.instantiate()
		child.text = e
		child.name = e
		elements.add_child(child)
