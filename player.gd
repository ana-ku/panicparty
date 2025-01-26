extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node

@onready var speech_bubble = $Label  # Adjust the path to the Label node

@onready var protective_bubble = $ProtectiveBubble


var intro_texts = [
	"I NEED to get out...",
	"I'm about to have a panic attack."
]

signal resilience_decreased(position_on_gradient)
signal resilience_depleted

var position_on_gradient : float
var can_move = true
var move_towards_npc = false
var target_position = Vector2.ZERO
var dialogueResource = null
var speed = 200  # Movement speed

var max_resilience = Global.max_resilience # The starting resilience
var current_resilience: int = max_resilience

func _ready():
	DialogueManager.dialogue_ended.connect(dialogue_ended_can_move)
	DialogueManager.got_dialogue.connect(count_resilience)
	
	for npc in get_tree().get_nodes_in_group("npcs"):
		npc.start_dialogue_with_npc.connect(self._move_to_npc)
	
	#Protective bubble
	protective_bubble.default_color = Color(1, 0.84, 0)
	
	start_intro_sequence()

func _process(_delta):
	if move_towards_npc:
		# Move toward the target NPC
		var direction = (target_position - global_position).normalized()
		velocity = direction * 200  # Adjust speed as needed
		move_and_slide()
		var distance_to = global_position.distance_to(target_position)
		# Check if close enough to the NPC
		if global_position.distance_to(target_position) < 111:  # Adjust distance threshold
			can_move = false  
			animated_sprite.play("default") 
			velocity = Vector2.ZERO
			move_towards_npc = false

# Disable player control for dialogue
	elif can_move:
		handle_input()

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
	can_move = true

func start_intro_sequence():
	# Disable player control
	# Show the speech bubble and start displaying texts
	speech_bubble.visible = true
	show_intro_texts()

func show_intro_texts():
	var delay = 1.5  # Seconds between texts
	for i in range(intro_texts.size()):
		await get_tree().create_timer(delay * i).timeout
		speech_bubble.text = intro_texts[i]
	await get_tree().create_timer(delay * intro_texts.size()).timeout
	speech_bubble.visible = false

func count_resilience(_lines):
	current_resilience -=1
	position_on_gradient = float(current_resilience) / float(max_resilience)
	print("Current resilience: ", current_resilience)
	print("Max resilience: ", max_resilience)
	change_color_protective_bubble(current_resilience)
	emit_signal("resilience_decreased", position_on_gradient)
	if current_resilience == 0:
		emit_signal("resilience_depleted")
	
	
func change_color_protective_bubble(current_resilience):
	var resilience_ratio = float(current_resilience) / float(max_resilience)
	var new_color = Color(1, resilience_ratio, 0)  # From red (1,0,0) to yellow (1,1,0)
	protective_bubble.modulate = new_color
	
