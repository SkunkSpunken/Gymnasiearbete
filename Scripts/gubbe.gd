extends CharacterBody2D
class_name Player

const MAX_SPEED = 60
const ACC = 5000

var last_direction = "Down"
var state = IDLE

enum{IDLE, WALK, USE_ITEM}

@onready var _animated_sprite = $AnimatedSprite2D



################ MOVEMENT ################

func _movement(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = velocity.move_toward(direction*MAX_SPEED, ACC*delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Hotbar1"):
		pass

################ STATE MACHINE ################

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if dir != Vector2.ZERO:
		_enter_walk_state()
	else:
		_enter_idle_state()
	
	match state:
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)
		USE_ITEM:
			_use_item_state(delta)



################ STATES ################

func _idle_state(_delta):
	_animated_sprite.play("Idle_" + last_direction)

func _walk_state(delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir.y < 0:
		_animated_sprite.play("Up")
		last_direction = "Up"
	elif dir.y > 0:
		_animated_sprite.play("Down")
		last_direction = "Down"
	elif dir.x > 0:
		_animated_sprite.play("Right")
		last_direction = "Right"
	elif dir.x < 0:
		_animated_sprite.play("Left")
		last_direction = "Left"
	_movement(delta)

func _use_item_state(_delta):
	pass


################ ENTER STATE ################

func _enter_idle_state():
	state = IDLE

func _enter_walk_state():
	state = WALK

func _enter_use_item_state():
	state = USE_ITEM


################ COLLISIONS BAJS ################

func _dissable_player_collision():
	set_collision_mask_value(3, false)

func _enable_player_collision():
	set_collision_mask_value(3, true)
