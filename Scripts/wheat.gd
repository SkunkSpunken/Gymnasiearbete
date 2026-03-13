extends Node2D

@onready var _wheat = $WheatSprite

var grown = false
var tile_pos
var farm_manager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_grow()


func _start_grow():
	await get_tree().create_timer(1).timeout
	_wheat.frame += 1
	await get_tree().create_timer(1).timeout
	_wheat.frame += 1
	await get_tree().create_timer(1).timeout
	_wheat.frame += 1
	await get_tree().create_timer(1).timeout
	_wheat.scale = Vector2(0.6, 0.6)
	_wheat.frame += 1
	_wheat.position.y += 2
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
		Global.wheat += 1
		farm_manager.planted_tiles.erase(tile_pos)
		queue_free()
