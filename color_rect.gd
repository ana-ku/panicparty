extends ColorRect

var progress_speed = 0.5  # Adjust speed of the animation
var current_progress = 0.0
var is_melting = false
@onready var shader_material = material as ShaderMaterial

func _ready() -> void:
	start_melt_animation()

func _process(delta):
	if is_melting:
		current_progress += delta * progress_speed
		current_progress = clamp(current_progress, 0.0, 1.0)  # Limit between 0 and 1
		shader_material.set("shader_param/progress", current_progress)
		if current_progress == 1.0:
			is_melting = false  # Stop melting when progress reaches 1.0

func start_melt_animation():
	is_melting = true
	current_progress = 0.0  # Reset progress
