extends UIActionPanel

const BattleLabel = preload("res://Game/Source/Scene/UI/BattleBasicLabel.tscn")

func _ready():
	elements = $MarginContainer/Elements

func setup(payload: Dictionary):
	for n in elements.get_children():
		elements.remove_child(n)
		n.queue_free() 
	
	var p_elements = payload["panel_elements"] as Array[String]
	if Assert.is_null_that_warns(p_elements, "WARNING: No elements found for SelectTargetPanel"):
		return
	
	for e in p_elements:
		var child = BattleLabel.instantiate()
		child.text = e
		child.name = e
		elements.add_child(child)
