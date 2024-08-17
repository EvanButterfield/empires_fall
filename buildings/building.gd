class_name Building extends Node3D

@export var building_name: String
@export var money_per_tick: int

func init() -> void:
	Globals.tick.connect(_on_tick)

func _on_tick() -> void:
	Globals.money += money_per_tick
