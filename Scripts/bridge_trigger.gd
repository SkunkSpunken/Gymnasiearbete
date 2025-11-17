extends Area2D

@onready var grass_layer: TileMapLayer = $"../Tilemaps/Grass"
@onready var hill_layer: TileMapLayer = $"../Tilemaps/Hills"
@onready var under_bridge_trigger: Area2D = $"../Under Bridge Trigger"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		grass_layer.collision_enabled = false
		hill_layer.collision_enabled = false
		under_bridge_trigger.monitoring = false

func _on_body_exited(body):
	if body.name == "Player":
		grass_layer.collision_enabled = true
		hill_layer.collision_enabled = true
		under_bridge_trigger.monitoring = true
