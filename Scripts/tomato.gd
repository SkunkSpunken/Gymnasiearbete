extends Node2D

@onready var _tomato = $TomatoSprite

var world_scene = preload("res://scenes/hej_världen.tscn")
var tomato_scene = preload("res://scenes/tomato.tscn")

var grown = false
var tile_pos
var farm_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_grow()


func _start_grow():
	await get_tree().create_timer(1).timeout
	_tomato.frame += 1
	await get_tree().create_timer(1).timeout
	_tomato.frame += 1
	await get_tree().create_timer(1).timeout
	_tomato.frame += 1
	await get_tree().create_timer(1).timeout
	_tomato.scale = Vector2(0.6, 0.6)
	_tomato.frame += 1
	_tomato.position.y += 4
	_tomato.position.x += 1
	grown = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entered:", body.name)
	if not body.is_in_group("Player"):
		print("wrong person")
		return
		
	if not grown:
		print("not grown")
		return
		
	elif grown:
		print("thanks")
		Global.tomato += 1
		farm_manager.planted_tiles.erase(tile_pos)
		queue_free()
