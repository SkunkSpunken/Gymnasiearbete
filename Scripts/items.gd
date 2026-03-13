extends Label


func _process(delta: float) -> void:
	if "Wood" in name:
		text = str(Global.wood)
	elif "Tomato" in name:
		text = str(Global.tomato)
	elif "Diamond" in name:
		text = str(Global.diamond)
	else:
		text = str(Global.wheat)
