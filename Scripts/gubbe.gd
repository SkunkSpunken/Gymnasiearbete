extends CharacterBody2D
class_name Player

const MAX_SPEED = 60
const ACC = 5000

var last_direction = "Down"
var state = IDLE
var active_item = IDLE
var hoed_tiles := {}

enum{IDLE, WALK, AXE, HOE, WATERINGCAN}

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _timer = $UseStateTimer
@onready var _hoe_timer = $HoeTimer
@onready var _tilemap = $"../Tilemaps/Tiled Dirt"


################ MOVEMENT ################

func _movement(delta: float) -> void:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = velocity.move_toward(input_dir * MAX_SPEED, ACC * delta)
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
	
	await get_tree().create_timer(0.8).timeout
	_change_tile_when_hoe()

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
	
	await get_tree().create_timer(1).timeout
	_water_tile_if_hoed()

func _change_tile_when_hoe():
	var offset_world = Vector2.ZERO
	
	if last_direction == "Right":
		offset_world = Vector2(10, 0)
	elif last_direction == "Left":
		offset_world = Vector2(-10, 0)
	elif last_direction == "Up":
		offset_world = Vector2(0, -10)
	else:                 #"Down"
		offset_world = Vector2(0, 10)
	
	var world_pos = global_position + offset_world
	var target_tile = _tilemap.local_to_map(world_pos)
	
	var terrain_set = 0
	var terrain_id = 1
	
	hoed_tiles[target_tile] = true

	_tilemap.set_cells_terrain_connect([target_tile], 0, 1)

func _water_tile_if_hoed():
	var offset_world = Vector2.ZERO
	
	if last_direction == "Right":
		offset_world = Vector2(10, 0)
	elif last_direction == "Left":
		offset_world = Vector2(-10, 0)
	elif last_direction == "Up":
		offset_world = Vector2(0, -10)
	else:                 #"Down"
		offset_world = Vector2(0, 10)
		
	var world_pos = global_position + offset_world
	var target_tile = _tilemap.local_to_map(world_pos)
	
	var terrain_set = 0
	var terrain_id = 1
	
	if not hoed_tiles.has(target_tile):
		return

	var tile_data: TileData = _tilemap.get_cell_tile_data(target_tile)
	if tile_data == null:
		return

	tile_data.modulate = Color(0.6, 0.6, 0.6)

func _facing_offset() -> Vector2i:
	if last_direction == "Right":
		return Vector2i(1, 0)
	if last_direction == "Left":
		return Vector2i(-1, 0)
	if last_direction == "Up":
		return Vector2i(0, -1)
	return Vector2i(0, 1)



################ COLLISIONS BAJS ################

func _dissable_player_collision():
	set_collision_mask_value(3, false)

func _enable_player_collision():
	set_collision_mask_value(3, true)

func _on_use_state_timer_timeout() -> void:
	_enter_idle_state()

func _on_hoe_timer_timeout() -> void:
	_enter_idle_state()
