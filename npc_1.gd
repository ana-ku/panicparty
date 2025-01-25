extends Node2D  # Or the NPC's root node type
@onready var animated_sprite = $AnimatedSprite2D  # Path to the AnimatedSprite2D node
signal start_dialogue_with_npc(npc_position)
@onready var detection_area = $DetectionArea
@onready var dialogue_bubble = get_node("Label")  # Path to the Label node

func _ready():
	# Set the animation to play automatically
	dialogue_bubble.visible = false
	animated_sprite.play("default")
	# Connect the signals for Area2D
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with the name of your player node
		print("Body entered")
		dialogue_bubble.visible = true
		emit_signal("start_dialogue_with_npc", global_position)

# This function is called when the player exits the NPC's area
func _on_body_exited(body):
	if body.name == "Player":
		dialogue_bubble.visible = false
