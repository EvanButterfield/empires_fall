class_name BuildingManager extends Node3D

@export var buildings: Array[Building]
var selected_building: int = 0

@export var current_building: Node3D

func _ready() -> void:
	var scene: PackedScene = get_selected_building().scene
	var node: Node3D = scene.instantiate()
	current_building.add_child(node)

func get_selected_building() -> Building:
	return buildings[selected_building]
