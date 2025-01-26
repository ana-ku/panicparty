extends Node2D

# Parametry kruhu
var min_radius = 90
var max_radius = 100
var oscillation_speed = 2.0
var segments = 64
var polygon
var polygon_butterfly_catcher
var polygon_podcaster
var collision_shape_painter
var collision_shape_butterfly_catcher
var collision_shape_podcaster

# Proměnné
var current_radius = min_radius  # Aktuální poloměr
var time_passed = 0.0  # Čas od spuštění

@onready var player = $Player
@onready var losing_panel = $LosingPanel
@onready var bg_shader = $BG_shader


# Called when the node enters the scene tree for the first time.
func _ready():
	losing_panel.visible = false
	bg_shader.visible = false
	
	var bus_index = AudioServer.get_bus_index("Master")
	var effect_index = 0
	var spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_index, effect_index)
	
	color_polygons()

@export var audio_player: AudioStreamPlayer
@export var lights: Array[PointLight2D] = []

# Frekvence pro efekt blikání
var low_band_energy: float = 0.0

func _process(delta):
	time_passed += delta * oscillation_speed
	current_radius = lerp(min_radius, max_radius, (sin(time_passed) + 1) / 2)
	
	update_circle()

	audio_player = get_node("/root/Node2D/BackgroundMusic")
	lights = [
		get_node("/root/Node2D/PointLight2D"),
		get_node("/root/Node2D/PointLight2D2"),
		get_node("/root/Node2D/PointLight2D3"),
		get_node("/root/Node2D/PointLight2D4"),
		get_node("/root/Node2D/PointLight2D5"),
		get_node("/root/Node2D/PointLight2D6"),
		get_node("/root/Node2D/PointLight2D7"),
		get_node("/root/Node2D/PointLight2D8"),
	]
	if audio_player.playing:
		# Získání frekvenční analýzy (pokud používáš SpectrumAnalyzerInstance)
		var spectrum = AudioServer.get_bus_effect_instance(0, 0).get_magnitude_for_frequency_range(100, 300)
		low_band_energy = clamp(spectrum[0], 0, 1) # Normalizace energie

		# Změna intenzity světla
		for light in lights:
			if light is PointLight2D:
				light.energy = lerp(light.energy, low_band_energy * 5.0, 0.2) # Efekt blikání		

	


func color_polygons():
	#set color to the circles
	for npc in get_tree().get_nodes_in_group("npcs"):
		polygon = npc.get_node("Polygon2D")
		var random_float = round(randf() * 10) / 10.0
		print("Random float: ", random_float)
		polygon.color = Color(random_float, 0.6, 1.0, 0.5)

		
	#polygon_butterfly_catcher = get_node("butterfly_catcher/Polygon2D")
	#polygon_butterfly_catcher.color = Color(0.8, 0.6, 1.0, 0.5)
	#polygon_podcaster = get_node("podcaster/Polygon2D")
	#polygon_podcaster.color = Color(0.2, 0.6, 1.0, 0.5)
	
	
func update_circle():
	for npc in get_tree().get_nodes_in_group("npcs"):
		var old_shape
		var points = []
		old_shape = npc.get_node("Area2D/CollisionShape2D").shape
		var new_shape = CircleShape2D.new()
		new_shape.radius = current_radius #The size that you want
		old_shape = new_shape
		
		for i in range(segments):
			var angle = 2 * PI * i / segments
			var x = current_radius * cos(angle)
			var y = current_radius * sin(angle)
			points.append(Vector2(x, y))
		polygon = npc.get_node("Polygon2D")
		polygon.polygon = points
		
		

func _on_player_resilience_depleted():
	losing_panel.visible = true
	player.can_move = false
	bg_shader.visible = true
	print("resilience depleted!")
	
func _on_replay_pressed():
	# Reload the current scene
	print("tlačítko zmáčknuto")
	bg_shader.visible = false
	get_tree().reload_current_scene()
