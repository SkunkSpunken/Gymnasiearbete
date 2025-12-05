extends Area2D

@onready var grass_layer: TileMapLayer = $"../Tilemaps/Grass"
@onready var hill_layer: TileMapLayer = $"../Tilemaps/Hills"
@onready var under_bridge_trigger: Area2D = $"../Under Bridge Trigger"

@export var player: Player
@export var chicken: Chicken
@export var cow: Cow



################ PLAYER COLLISION ################
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body._dissable_player_collision()
		under_bridge_trigger.monitoring = false
	elif body is Chicken:
		body._dissable_chicken_collision()
		under_bridge_trigger.monitoring = false
	elif body is Cow:
		body._dissable_cow_collision()
		under_bridge_trigger.monitoring = false

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body._enable_player_collision()
		under_bridge_trigger.monitoring = true
	elif body is Chicken:
		body._enable_chicken_collision()
		under_bridge_trigger.monitoring = true
	elif body is Cow:
		body._enable_cow_collision()
		under_bridge_trigger.monitoring = true
