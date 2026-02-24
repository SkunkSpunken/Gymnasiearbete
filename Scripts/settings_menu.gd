extends Control

func _ready():
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		back_to_pause()

func _on_back_pressed():
	back_to_pause()

func back_to_pause():
	visible = false
	get_parent().get_node("PauseMenu").visible = true
