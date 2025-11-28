extends Area2D

@onready var bridge_layer: TileMapLayer = $"../Tilemaps/Bridge"
@onready var nature_layer: TileMapLayer = $"../Tilemaps/Nature1"
@onready var bridge_trigger: Area2D = $"../Bridge Trigger"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		bridge_layer.z_index += 1
		nature_layer.z_index += 1
		bridge_layer.collision_enabled = false
		bridge_trigger.monitoring = false

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		bridge_layer.z_index -= 1
		nature_layer.z_index -= 1
		bridge_layer.collision_enabled = true
		bridge_trigger.monitoring = true
