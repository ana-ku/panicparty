extends Area2D

@onready var line = $Line2D  # Reference to the Line2D node

var radius = 100  # Set the radius of the bubble

func _ready():
	# Draw the golden circle (protective bubble)
	line.default_color = Color(1, 0.84, 0)  # Gold color
	line.width = 4  # Set the width of the circle's line
	line.points = [Vector2(-10, -10), Vector2(10, -10)]
	#draw_protective_bubble()
	print(line.points)
	
func draw_protective_bubble():
	var points = []
	var segments = 64  # The number of segments to approximate the circle

	for i in range(segments + 1):  # +1 to close the circle
		var angle = i * (2 * PI / segments)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))

	line.points = points  # Assign the calculated points to the Line2D
