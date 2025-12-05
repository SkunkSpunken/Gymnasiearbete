extends CharacterBody2D
class_name Cow

const MAX_SPEED = 20

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _timer = $Timer

var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _ready() -> void:
	_timer.wait_time = randf_range(2, 5)
	_timer.start()

func _walk() -> void:
	velocity = dir * MAX_SPEED
	move_and_slide()
	
func _physics_process(_delta: float) -> void:
	_walk()
	if velocity.x > 0:
		_animated_sprite.flip_h = false
		_animated_sprite.play("Walk")
	elif velocity.x < 0:
		_animated_sprite.flip_h = true
		_animated_sprite.play("Walk")
	elif velocity.x == 0:
		_animated_sprite.play("Idle")

func _on_timer_timeout() -> void:
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	_timer.wait_time = randf_range(2, 5)
	_timer.start()

################ COLLISIONS ################
func _dissable_cow_collision():
	set_collision_mask_value(3, false)

func _enable_cow_collision():
	set_collision_mask_value(3, true)
