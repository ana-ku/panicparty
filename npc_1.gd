extends Node2D  # Or the NPC's root node type
@onready var animated_sprite = $AnimatedSprite2D  # Path to the AnimatedSprite2D node

signal start_dialogue_with_npc(npc_position)

var is_active = true

@onready var detection_area = $Area2D
@onready var dialogue_bubble = get_node("Label")  # Path to the Label node

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func _ready():
	# Set the animation to play automatically
	dialogue_bubble.visible = false
	animated_sprite.play("default")
	# Connect the signals for Area2D
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))
	#DialogueManager.dialogue_ended.connect(can_move)

func _on_body_entered(body):
	if not is_active:
		return
	
	if body.name == "Player":  # Replace "Player" with the name of your player node
		dialogue_bubble.visible = true
		emit_signal("start_dialogue_with_npc", self)
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

# This function is called when the player exits the NPC's area
func _on_body_exited(body): #kdyz hráč opustí, už npc nebude fungovat
	if body.name == "Player":
		dialogue_bubble.visible = false
		is_active = false
