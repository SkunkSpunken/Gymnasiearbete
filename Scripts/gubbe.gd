extends CharacterBody2D
class_name Player

######### PLAYER CONST ###########
const MAX_SPEED = 60
const ACC = 5000

############ TREE CONST #############
const TREE_LAYER = 0
const SOURCE_ID = 0

const TREE_TILE = Vector2i(0, 0)
const STUMP_TILE  = Vector2i(4, 2)

############# PLAYER VAR ##############
var last_direction = "Down"
var state = IDLE
var active_item = IDLE

############# TILES VAR ##############
var hoed_tiles := {}
var watered_tiles := {}
var planted_tiles = {}

############## PLANT CROPS VAR ###############
var wheat_scene = preload("res://scenes/wheat.tscn")
var tomato_scene = preload("res://scenes/tomato.tscn")

enum{IDLE, WALK, AXE, HOE, WATERINGCAN, WHEATSEED, TOMATOSEED}

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _timer = $UseStateTimer
@onready var _hoe_timer = $HoeTimer
@onready var _tiled_dirt = $"../Tilemaps/Tiled Dirt"
@onready var _trees = $"../YSortTimemaps/Trees"



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
		
	if event.is_action_pressed("Hotbar4"):
		active_item = WHEATSEED
		
	if event.is_action_pressed("Hotbar5"):
		active_item = TOMATOSEED
		
	if event.is_action_pressed("UseItem"):
		
		match active_item:
			AXE:
				_enter_axe_state()
			HOE:
				_enter_hoe_state()
			WATERINGCAN:
				_enter_wateringcan_state()
			WHEATSEED:
				_enter_wheatseed_state()
			TOMATOSEED:
				_enter_tomatoseed_state()



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
		WHEATSEED:
			_wheatseed_state(delta)
		TOMATOSEED:
			_tomatoseed_state(delta)



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

func _wheatseed_state(_delta):
	pass

func _tomatoseed_state(delta):
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
	
	
	
	await get_tree().create_timer(1).timeout
	_axe_tree()

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

func _enter_wheatseed_state():
	state = WHEATSEED
	
	if last_direction == "Up":
		_animated_sprite.play("Water_Up")
	elif last_direction == "Down":
		_animated_sprite.play("Water_Down")
	elif last_direction == "Left":
		_animated_sprite.play("Water_Left")
	elif last_direction == "Right":
		_animated_sprite.play("Water_Right")
	
	_plant_wheat()

func _enter_tomatoseed_state():
	state = TOMATOSEED
	
	if last_direction == "Up":
		_animated_sprite.play("Water_Up")
	elif last_direction == "Down":
		_animated_sprite.play("Water_Down")
	elif last_direction == "Left":
		_animated_sprite.play("Water_Left")
	elif last_direction == "Right":
		_animated_sprite.play("Water_Right")
	
	_plant_tomato()


################ STATE FUNCTIONS ################

func _axe_tree():
	var player_cell = _trees.local_to_map(_trees.to_local(global_position))
	
	for y in range(-1, 1):
		for x in range(-1, 1):
			var check_cell = player_cell + Vector2i(x, y)
			var source = _trees.get_cell_source_id(check_cell)
			
			if source != -1:
				print("Tree found at:", check_cell)
				_trees.erase_cell(check_cell)
				_place_stump(check_cell)
				Global.wood += 1
				return


func _place_stump(cell: Vector2i):
	_trees.set_cell(cell, 3, STUMP_TILE)
	print(_trees.get_cell_source_id(cell))


func _change_tile_when_hoe():
	var offset_world = Vector2.ZERO
	
	if last_direction == "Right":
		offset_world = Vector2(10, 0)
	elif last_direction == "Left":
		offset_world = Vector2(-10, 0)
	elif last_direction == "Up":
		offset_world = Vector2(0, -8)
	else:                 #"Down"
		offset_world = Vector2(0, 8)
	
	var world_pos = global_position + offset_world
	var target_tile = _tiled_dirt.local_to_map(world_pos)
	
	hoed_tiles[target_tile] = true
	
	_tiled_dirt.set_cells_terrain_connect([target_tile], 0, 1)



func _water_tile_if_hoed():
	var offset_world = Vector2.ZERO
	
	if last_direction == "Right":
		offset_world = Vector2(10, 0)
	elif last_direction == "Left":
		offset_world = Vector2(-10, 0)
	elif last_direction == "Up":
		offset_world = Vector2(0, -8)
	else:                 #"Down"
		offset_world = Vector2(0, 8)
		
	var world_pos = global_position + offset_world
	var target_tile = _tiled_dirt.local_to_map(world_pos)
	
	if not hoed_tiles.has(target_tile):
		return

	var tile_data: TileData = _tiled_dirt.get_cell_tile_data(target_tile)
	if tile_data == null:
		return

	tile_data.modulate = Color(0.8, 0.8, 0.8)



func _plant_wheat():
	var offset_world = Vector2.ZERO
	
	if last_direction == "Right":
		offset_world = Vector2(10, 0)
	elif last_direction == "Left":
		offset_world = Vector2(-10, 0)
	elif last_direction == "Up":
		offset_world = Vector2(0, -8)
	else:
		offset_world = Vector2(0, 8)
		
	var world_pos = global_position + offset_world
	var target_tile = _tiled_dirt.local_to_map(world_pos)
	
	if not hoed_tiles.has(target_tile):
		return
		
	if planted_tiles.has(target_tile):
		print("Crop already here")
		return
	
	var wheat_instance = wheat_scene.instantiate()
	
	var tile_world_pos = _tiled_dirt.map_to_local(target_tile)
	wheat_instance.global_position = tile_world_pos
	
	wheat_instance.tile_pos = target_tile
	wheat_instance.farm_manager = self
	
	get_parent().find_child("Crops").add_child(wheat_instance)
	
	planted_tiles[target_tile] = wheat_instance



func _plant_tomato():
	var offset_world = Vector2.ZERO
	
	if last_direction == "Right":
		offset_world = Vector2(10, 0)
	elif last_direction == "Left":
		offset_world = Vector2(-10, 0)
	elif last_direction == "Up":
		offset_world = Vector2(0, -8)
	else:                 #"Down"
		offset_world = Vector2(0, 8)
	
	var world_pos = global_position + offset_world
	var target_tile = _tiled_dirt.local_to_map(world_pos)
	
	if not hoed_tiles.has(target_tile):
		print("Bajs")
		return
		
	if planted_tiles.has(target_tile):
		print("Crop already here")
		return
	
	var tomato_instance = tomato_scene.instantiate()
	
	var tile_world_pos = _tiled_dirt.map_to_local(target_tile)
	tomato_instance.global_position = tile_world_pos
	
	tomato_instance.tile_pos = target_tile
	tomato_instance.farm_manager = self
	
	get_parent().find_child("Crops").add_child(tomato_instance)
	
	planted_tiles[target_tile] = tomato_instance


func _facing_offset() -> Vector2i:
	if last_direction == "Up":
		return Vector2i(0, -2)
	if last_direction == "Down":
		return Vector2i(0, 1)
	if last_direction == "Left":
		return Vector2i(-1, 0)
	return Vector2i(1, 0)



################ COLLISIONS BAJS ################

func _dissable_player_collision():
	set_collision_mask_value(3, false)

func _enable_player_collision():
	set_collision_mask_value(3, true)

func _on_use_state_timer_timeout() -> void:
	_enter_idle_state()

func _on_hoe_timer_timeout() -> void:
	_enter_idle_state()
