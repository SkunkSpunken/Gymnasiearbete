extends Sprite2D


func _input(event):
	if find_parent("HotbarButton1"):
		if event.is_action_pressed("Hotbar1"):
			position.y = 14
		if event.is_action_pressed("Hotbar2"):
			position.y = 12
		if event.is_action_pressed("Hotbar3"):
			position.y = 12
		if event.is_action_pressed("Hotbar4"):
			position.y = 12
		if event.is_action_pressed("Hotbar5"):
			position.y = 12

	elif find_parent("HotbarButton2"):
		if event.is_action_pressed("Hotbar1"):
			position.y = 12
		if event.is_action_pressed("Hotbar2"):
			position.y = 14
		if event.is_action_pressed("Hotbar3"):
			position.y = 12
		if event.is_action_pressed("Hotbar4"):
			position.y = 12
		if event.is_action_pressed("Hotbar5"):
			position.y = 12

	elif find_parent("HotbarButton3"):
		if event.is_action_pressed("Hotbar1"):
			position.y = 12
		if event.is_action_pressed("Hotbar2"):
			position.y = 12
		if event.is_action_pressed("Hotbar3"):
			position.y = 14
		if event.is_action_pressed("Hotbar4"):
			position.y = 12
		if event.is_action_pressed("Hotbar5"):
			position.y = 12

	elif find_parent("HotbarButton4"):
		if event.is_action_pressed("Hotbar1"):
			position.y = 12
		if event.is_action_pressed("Hotbar2"):
			position.y = 12
		if event.is_action_pressed("Hotbar3"):
			position.y = 12
		if event.is_action_pressed("Hotbar4"):
			position.y = 14
		if event.is_action_pressed("Hotbar5"):
			position.y = 12

	elif find_parent("HotbarButton5"):
		if event.is_action_pressed("Hotbar1"):
			position.y = 12
		if event.is_action_pressed("Hotbar2"):
			position.y = 12
		if event.is_action_pressed("Hotbar3"):
			position.y = 12
		if event.is_action_pressed("Hotbar4"):
			position.y = 12
		if event.is_action_pressed("Hotbar5"):
			position.y = 14
