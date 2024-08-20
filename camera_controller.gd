class_name CameraController extends Node3D

@export var building_manager: BuildingManager
@export var buildings: Node3D
@export var current_building: Node3D

@export var speed: float = 1.0

@export var max_zoom: float = 20.0
@export var min_zoom: float = 8.0
@export var zoom_speed: float = 1.0

@onready var camera: Camera3D = $Camera3D

var building_particle = preload("res://building_particle.tscn")

var selected_grid_index: int
var selected_grid_position: Vector3

func _process(delta: float) -> void:
	if Globals.paused:
		return
	
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	position += speed * ((basis.x * input.x) + (basis.z * input.y))
	var grid_size: float = Globals.grid.grid_dimension * Globals.grid.grid_tile_size / 2
	position.x = clamp(position.x, -grid_size, grid_size)
	position.z = clamp(position.z, -grid_size, grid_size)
	
	if Input.is_action_just_pressed("zoom_in"):
		position.y -= zoom_speed
		position.y = max(position.y, min_zoom)
	
	if Input.is_action_just_pressed("zoom_out"):
		position.y += zoom_speed
		position.y = min(position.y, max_zoom)
	
	var selected_used: Building = Globals.grid.used[selected_grid_index]
	if !selected_used:
		current_building.visible = true
		
		if Input.is_action_pressed("interact"):
			var building_scene: PackedScene = building_manager.get_selected_building()
			var building: Building = building_scene.instantiate()
			if Globals.money >= building.cost:
				Globals.money -= building.cost
				building.position = selected_grid_position
				building.rotation.y = current_building.rotation.y
				buildings.add_child(building)
				building.init(selected_grid_index)
				Globals.grid.used[selected_grid_index] = building
				Globals.buildings_changed.emit()
				Globals.total_buildings_money += building.cost
				
				var particle: GPUParticles3D = building_particle.instantiate()
				particle.position = selected_grid_position
				get_tree().current_scene.add_child(particle)
	
	if selected_used:
		current_building.visible = false
		
		if Input.is_action_pressed("delete"):
			Globals.money += selected_used.cost / 2
			selected_used.queue_free()
			Globals.grid.used[selected_grid_index] = null
			Globals.buildings_changed.emit()
			Globals.total_buildings_money -= selected_used.cost
	
	if Input.is_action_just_pressed("rotate"):
		current_building.rotation_degrees.y += 90

func _physics_process(delta: float) -> void:
	if Globals.paused:
		return
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	var origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var end: Vector3 = origin + camera.project_ray_normal(mouse_pos) * 100
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end, 2)
	
	var result: Dictionary = space_state.intersect_ray(query)
	if result:
		var ground_position: Vector3 = result["position"]
		selected_grid_index = Globals.grid.get_nearest_grid_index(ground_position.x, ground_position.z)
		selected_grid_position = Globals.grid.get_nearest_grid_point(selected_grid_index)
		current_building.position = selected_grid_position
