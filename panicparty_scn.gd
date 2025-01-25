extends Node2D

# Parametry kruhu
var min_radius = 100
var max_radius = 130
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

var victory_panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	var effect_index = 0
	var spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_index, effect_index)
	victory_panel = $Panel
	victory_panel.visible = false
	polygon = get_node("painter/Polygon2D")
	polygon.color = Color(0.6, 0.6, 1.0, 0.5)
	polygon_butterfly_catcher = get_node("butterfly_catcher/Polygon2D")
	polygon_butterfly_catcher.color = Color(0.8, 0.6, 1.0, 0.5)
	polygon_podcaster = get_node("podcaster/Polygon2D")
	polygon_podcaster.color = Color(0.2, 0.6, 1.0, 0.5)

@export var audio_player: AudioStreamPlayer
@export var lights: Array[PointLight2D] = []

# Frekvence pro efekt blikání
var low_band_energy: float = 0.0

func _process(delta):
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

	time_passed += delta * oscillation_speed
	current_radius = lerp(min_radius, max_radius, (sin(time_passed) + 1) / 2)
	update_circle()
	
func update_circle():
	var points = []
	for i in range(segments):
		var angle = 2 * PI * i / segments
		var x = current_radius * cos(angle)
		var y = current_radius * sin(angle)
		points.append(Vector2(x, y))

	polygon.polygon = points
	polygon_butterfly_catcher.polygon = points
	polygon_podcaster.polygon = points
	collision_shape_painter = get_node("painter/Area2D/CollisionShape2D")
	collision_shape_painter.shape.radius = current_radius
	
	collision_shape_butterfly_catcher = get_node("butterfly_catcher/Area2D/CollisionShape2D")
	collision_shape_butterfly_catcher.shape.radius = current_radius
	
	collision_shape_podcaster = get_node("podcaster/Area2D/CollisionShape2D")
	collision_shape_podcaster.shape.radius = current_radius
