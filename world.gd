extends Node3D

@onready var hud: Control = $HUD
@onready var current_money_label: Label = $HUD/CurrentMoneyLabel
@onready var pause_menu: Control = $PauseMenu

func _process(delta: float) -> void:
	current_money_label.text = "%d Money" % Globals.money
	
	if Input.is_action_just_pressed("pause"):
		Globals.paused = true
		hud.visible = false
		pause_menu.visible = true

func _on_play_button_pressed():
	Globals.paused = false
	hud.visible = true
	pause_menu.visible = false

func _on_quit_button_pressed():
	get_tree().quit()
