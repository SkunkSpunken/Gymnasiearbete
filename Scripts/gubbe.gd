extends CharacterBody2D
class_name Player

signal dead

const MAX_SPEED = 60
const ACC = 5000

var last_direction = "Down"

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		_animated_sprite.play("Up")
		last_direction = "Up"
		
	elif Input.is_action_pressed("ui_down"):
		_animated_sprite.play("Down")
		last_direction = "Down"
		
	elif Input.is_action_pressed("ui_right"):
		_animated_sprite.play("Right")
		last_direction = "Right"
		
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.play("Left")
		last_direction = "Left"
		
	else:
		_animated_sprite.play("Idle_" + last_direction)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = velocity.move_toward(direction*MAX_SPEED, ACC*delta)
	move_and_slide()
