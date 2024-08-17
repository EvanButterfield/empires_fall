class_name CameraController extends Node3D

@export var building_manager: BuildingManager
@export var buildings: Node3D
@export var current_building: Node3D

@export var grid: GridVisualizer
@export var selected_grid_mesh_instance: MeshInstance3D

@export var speed: float = 1.0

@export var max_zoom: float = 20.0
@export var min_zoom: float = 8.0
@export var zoom_speed: float = 1.0

@onready var camera: Camera3D = $Camera3D

var selected_grid_index: int
var selected_grid_position: Vector3

func _process(delta: float) -> void:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	position += speed * ((basis.x * input.x) + (basis.z * input.y))
	
	if Input.is_action_just_pressed("zoom_in"):
		position.y -= zoom_speed
		position.y = max(position.y, min_zoom)
	
	if Input.is_action_just_pressed("zoom_out"):
		position.y += zoom_speed
		position.y = min(position.y, max_zoom)
	
	if !grid.used[selected_grid_index] and Input.is_action_pressed("interact"):
		var building_scene: PackedScene = building_manager.get_selected_building()
		var building: Building = building_scene.instantiate()
		building.position = selected_grid_position
		buildings.add_child(building)
		building.init()
		grid.used[selected_grid_index] = true

func _physics_process(delta: float) -> void:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	var origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var end: Vector3 = origin + camera.project_ray_normal(mouse_pos) * 100
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end, 2)
	
	var result: Dictionary = space_state.intersect_ray(query)
	if result:
		var ground_position: Vector3 = result["position"]
		selected_grid_index = grid.get_nearest_grid_index(ground_position.x, ground_position.z)
		selected_grid_position = grid.get_nearest_grid_point(selected_grid_index)
		selected_grid_mesh_instance.position = selected_grid_position
		current_building.position = selected_grid_position
