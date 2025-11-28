extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Vector2(3, 3)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		Vector2(2.5, 2.5)
