extends Area2D

@onready var roof_layer = $"../Tilemaps/Roof"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		roof_layer.visible = false

func _on_body_exited(body):
	if body.name == "Player":
		roof_layer.visible = true
