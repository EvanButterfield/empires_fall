extends Control

func _on_play_button_pressed():
	Globals.switch_scene(Globals.SCENES.WORLD)

func _on_quit_button_pressed():
	get_tree().quit()
