extends Control


func _ready() -> void:
	visible = false


func _process(_delta):
	_esc()


func _resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("Fade in")


func _pause():
	get_tree().paused = true
	$AnimationPlayer.play("Fade in")


func _esc():
	if Input.is_action_just_pressed("Escape") and !get_tree().paused:
		visible = true
		_pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused:
		visible = false
		_resume()



func _on_resume_pressed() -> void:
	_resume()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
