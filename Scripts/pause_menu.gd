extends Control

@onready var settings_menu = $"../Settings"


var is_paused = false

func _ready():
	visible = false
	set_process(true)

func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		if is_paused:
			resume_game()
		else:
			pause_game()

func pause_game():
	is_paused = true
	get_tree().paused = true
	visible = true
	$AnimationPlayer.play("Fade in")

func resume_game():
	is_paused = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("Fade in")
	await $AnimationPlayer.animation_finished
	visible = false

func _on_resume_pressed():
	resume_game()

func _on_settings_pressed():
	print("Pressed")
	visible = false
	settings_menu.visible = true
	settings_menu.move_to_front()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
