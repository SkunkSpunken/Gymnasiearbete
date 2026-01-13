extends Area2D

@onready var roof_layer = $"../YSortTimemaps/Roof"



func _on_body_entered(body):
	if body.name == "Player":
		roof_layer.visible = false

func _on_body_exited(body):
	if body.name == "Player":
		roof_layer.visible = true
