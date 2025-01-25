extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node

var speed = 200  # Movement speed

func _ready():
	print("Ready")
	
func _process(delta):
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
