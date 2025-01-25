extends CanvasLayer
var victory_panel

func _ready():
	victory_panel = $Panel
	
	victory_panel.visible = false
func _on_player_reached_victory():
	victory_panel.visible = true
	print("Victory! Player has escaped the party.")
