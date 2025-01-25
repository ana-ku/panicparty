extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
var can_move = true
var move_towards_npc = false
var target_position = Vector2.ZERO
var dialogueResource = null
var speed = 200  # Movement speed
@export var max_resilience: int = 100  # The starting resilience
var current_resilience: int = max_resilience


func _ready():
	DialogueManager.dialogue_ended.connect(dialogue_ended_can_move)
	for npc in get_tree().get_nodes_in_group("npcs"):
		npc.start_dialogue_with_npc.connect(self._move_to_npc)
func _process(_delta):
	if move_towards_npc:
		# Move toward the target NPC
		var direction = (target_position - global_position).normalized()
		velocity = direction * 200  # Adjust speed as needed
		move_and_slide()
		# Check if close enough to the NPC
		if global_position.distance_to(target_position) < 100:  # Adjust distance threshold
			can_move = false  
			animated_sprite.play("default") 
			velocity = Vector2.ZERO
			move_towards_npc = false

# Disable player control for dialogue
	elif can_move:
		handle_input()
		print(can_move)

func handle_input():
	# Get movement input from arrow keys
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	# Set velocity for movement
	velocity = input * speed

	# Play the corresponding animation based on input direction
	if input == Vector2.ZERO:
		animated_sprite.play("default")  # Idle animation
	elif input.x > 0:  # Moving right
		animated_sprite.play("walk_right")
	elif input.x < 0:  # Moving left
		animated_sprite.play("walk_left")
	elif input.y < 0:  # Moving up
		animated_sprite.play("walk_up")
	elif input.y > 0:  # Moving down (fallback to idle in this case)
		animated_sprite.play("default") 

	# Move the character
	move_and_slide()
	
# Signal handler to move toward the NPC
func _move_to_npc(npc):
	target_position = npc.global_position
	move_towards_npc = true
	dialogueResource = npc.dialogue_resource

func dialogue_ended_can_move(_resource):
	print("Has Ended")
	can_move = true
