extends Node2D  # Or the NPC's root node type

@onready var animated_sprite = $AnimatedSprite2D  # Path to the AnimatedSprite2D node

func _ready():
	# Set the animation to play automatically
	animated_sprite.play("default")
