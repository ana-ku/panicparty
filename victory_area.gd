extends Area2D

var victory_panel

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with your player's node name
		victory_panel = get_node("/root/Node2D/Panel")
		victory_panel.visible = true
		print("Victory! Player has escaped the party.")
