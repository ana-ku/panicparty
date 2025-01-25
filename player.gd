extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node

var speed = 200  # Movement speed
var can_move = true
var move_towards_npc = false
var target_position = Vector2.ZERO

func _ready():
		for npc in get_tree().get_nodes_in_group("npcs"):  # Ensure NPCs are in the "npcs" group
			npc.connect("start_dialogue_with_npc", Callable(self, "_move_to_npc"))

func _process(delta):
		# Get movement input from arrow keys
	if move_towards_npc:
		print("Move towards NPC YES")
		# Move toward the target NPC
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed  # Adjust speed as needed
				# Check if close enough to the NPC
		var distanceTo = global_position.distance_to(target_position)
		print("Pohyb: ", distanceTo)
		move_and_slide()
		if distanceTo < 80:  # Adjust distance threshold
			velocity = Vector2.ZERO
			move_towards_npc = false
			can_move = false # Disable player control for dialogue
	elif can_move:
		handle_input()
		
		
func handle_input():
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
func _move_to_npc(npc_position):
	target_position = npc_position
	move_towards_npc = true
