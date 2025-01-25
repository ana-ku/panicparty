extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	var effect_index = 0
	var spectrum_analyzer = AudioServer.get_bus_effect_instance(bus_index, effect_index)

@export var audio_player: AudioStreamPlayer
@export var lights: Array[PointLight2D] = []

# Frekvence pro efekt blikání
var low_band_energy: float = 0.0

func _process(delta):
	audio_player = get_node("/root/Node2D/BackgroundMusic")
	lights = [
		get_node("PointLight2D"),
		get_node("PointLight2D2"),
		get_node("PointLight2D3"),
		get_node("PointLight2D4"),
		get_node("PointLight2D5"),
		get_node("PointLight2D6"),
		get_node("PointLight2D7"),
		get_node("PointLight2D8"),
	]
	if audio_player.playing:
		# Získání frekvenční analýzy (pokud používáš SpectrumAnalyzerInstance)
		var spectrum = AudioServer.get_bus_effect_instance(0, 0).get_magnitude_for_frequency_range(100, 300)
		low_band_energy = clamp(spectrum[0], 0, 1) # Normalizace energie

		# Změna intenzity světla
		for light in lights:
			if light is PointLight2D:
				light.energy = lerp(light.energy, low_band_energy * 5.0, 0.2) # Efekt blikání		
		
