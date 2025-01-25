extends Control

# Exported variables for easy adjustments in the Inspector
@onready var gradient_texture_rect = $Gradient  # Reference to the gradient texture rect

@onready var arrow_sprite = $Sprite2D  # The Sprite2D representing the arrow

@onready var gradient_height = $Measure.get_node("CollisionShape2D").shape.size.y
@onready var one_arrow_movedown = float(gradient_height)/float(max_resilience)
var max_resilience = Global.max_resilience
var min_resilience = Global.min_resilience

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_resilience_decreased(position_on_gradient):
	
	#vypočítat jedno procento z measure
	
	
	print("Posun šipky: ", one_arrow_movedown)
	
	
	#o kolik procent je potřeba posunout šipku? = position on gradient
	arrow_sprite.position.y = arrow_sprite.position.y + one_arrow_movedown
	#kolik je to pixelů z measure
	
