class_name BuildingManager extends Node3D

@export var buildings: Array[PackedScene]
var selected_building: int = 0

@export var current_building: Node3D

func _ready() -> void:
	change_current_building()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cycle_building_left"):
		if selected_building == 0:
			selected_building = buildings.size() - 1
		else:
			selected_building -= 1
		change_current_building()
	
	if Input.is_action_just_pressed("cycle_building_right"):
		if selected_building == buildings.size() - 1:
			selected_building = 0
		else:
			selected_building += 1
		change_current_building()

func change_current_building() -> void:
	for child in current_building.get_children():
		child.queue_free()
	
	var scene: PackedScene = get_selected_building()
	var node: Node3D = scene.instantiate()
	current_building.add_child(node)

func get_selected_building() -> PackedScene:
	return buildings[selected_building]
