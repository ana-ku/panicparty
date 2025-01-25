extends Area2D

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with your player's node name
		emit_signal("player_reached_victory")
