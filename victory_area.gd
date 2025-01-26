extends Area2D

@onready var victory_panel = $Panel

func _ready() -> void:
	victory_panel.visible = false

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with your player's node name
		victory_panel.visible = true
		print("Victory! Player has escaped the party.")
