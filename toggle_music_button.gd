extends Button

var music_player

func _ready():

	music_player = get_node("/root/Node2D/CanvasLayer/BackgroundMusic")
	if music_player == null:
		print("Node 'BackgroundMusic' not found!")
		return
	else:
		print("Music player found: ", music_player)

	connect("pressed", Callable(self, "_on_button_pressed"))
	update_button_text()

func _on_button_pressed():
	if music_player:
		if music_player.playing:
			music_player.stop()
		else:
			music_player.play()
		update_button_text()

func update_button_text():
	self.text = "Mute Music" if music_player and music_player.playing else "Unmute Music"
