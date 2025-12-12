extends CharacterBody2D
class_name Player

const MAX_SPEED = 60
const ACC = 5000

var last_direction = "Down"
var state = IDLE
var active_item = IDLE

enum{IDLE, WALK, AXE, HOE, WATERINGCAN}

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _timer = $UseStateTimer


################ MOVEMENT ################

func _movement(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = velocity.move_toward(direction*MAX_SPEED, ACC*delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Hotbar1"):
		active_item = AXE
		
	if event.is_action_pressed("Hotbar2"):
		active_item = HOE
		
	if event.is_action_pressed("Hotbar3"):
		active_item = WATERINGCAN
		
	if event.is_action_pressed("UseItem"):
		
		match active_item:
			AXE:
				_enter_axe_state()
			HOE:
				_enter_hoe_state()
			WATERINGCAN:
				_enter_wateringcan_state()


################ STATE MACHINE ################

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if state not in [HOE, AXE, WATERINGCAN]:
		if dir != Vector2.ZERO:
			_enter_walk_state()
		else:
			_enter_idle_state()
	
	match state:
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)
		AXE:
			_axe_state(delta)
		HOE:
			_hoe_state(delta)
		WATERINGCAN:
			_wateringcan_state(delta)
	print(state, active_item)


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
	

func _axe_state(_delta):
	pass

func _hoe_state(_delta):
	pass

func _wateringcan_state(_delta):
	pass

################ ENTER STATE ################

func _enter_idle_state():
	state = IDLE

func _enter_walk_state():
	state = WALK

func _enter_axe_state():
	state = AXE
	_timer.start()
	if last_direction == "Up":
		_animated_sprite.play("Axe_Up")
	elif last_direction == "Down":
		_animated_sprite.play("Axe_Down")
	elif last_direction == "Left":
		_animated_sprite.play("Axe_Left")
	elif last_direction == "Right":
		_animated_sprite.play("Axe_Right")

func _enter_hoe_state():
	state = HOE
	_timer.start()
	if last_direction == "Up":
		_animated_sprite.play("Hoe_Up")
	elif last_direction == "Down":
		_animated_sprite.play("Hoe_Down")
	elif last_direction == "Left":
		_animated_sprite.play("Hoe_Left")
	elif last_direction == "Right":
		_animated_sprite.play("Hoe_Right")

func _enter_wateringcan_state():
	state = WATERINGCAN
	_timer.start()
	if last_direction == "Up":
		_animated_sprite.play("Water_Up")
	elif last_direction == "Down":
		_animated_sprite.play("Water_Down")
	elif last_direction == "Left":
		_animated_sprite.play("Water_Left")
	elif last_direction == "Right":
		_animated_sprite.play("Water_Right")


################ COLLISIONS BAJS ################

func _dissable_player_collision():
	set_collision_mask_value(3, false)

func _enable_player_collision():
	set_collision_mask_value(3, true)

"""
func _on_animated_sprite_2d_animation_finished() -> void:
	if _animated_sprite.animation == "Axe_Up":
		_enter_idle_state()
	elif _animated_sprite.animation == "Axe_Down":
		_enter_idle_state()
	elif _animated_sprite.animation == "Axe_Left":
		_enter_idle_state()
	elif _animated_sprite.animation == "Axe_Right":
		_enter_idle_state()
	
	if _animated_sprite.animation == "Hoe_Up":
		_enter_idle_state()
	elif _animated_sprite.animation == "Hoe_Down":
		_enter_idle_state()
	elif _animated_sprite.animation == "Hoe_Left":
		_enter_idle_state()
	elif _animated_sprite.animation == "Hoe_Right":
		_enter_idle_state()
	
	if _animated_sprite.animation == "Water_Up":
		_enter_idle_state()
	elif _animated_sprite.animation == "Water_Down":
		_enter_idle_state()
	elif _animated_sprite.animation == "Water_Left":
		_enter_idle_state()
	elif _animated_sprite.animation == "Water_Right":
		_enter_idle_state()
"""

func _on_use_state_timer_timeout() -> void:
	_enter_idle_state()
