@tool
class_name GridVisualizer extends Node3D

@export var selected_grid_mesh_instance: MeshInstance3D:
	set(new_selected_grid_mesh_instance):
		selected_grid_mesh_instance = new_selected_grid_mesh_instance
		_on_changed()

@export var grid_dimension: int = 2:
	set(new_grid_dimension):
		grid_dimension = new_grid_dimension
		if grid_dimension < 0:
			grid_dimension = 0
		if grid_dimension > 128:
			grid_dimension = 128
		
		_on_changed()

var half_grid_tile_size: float = 0.25
@export var grid_tile_size: float = 0.5:
	set(new_grid_tile_size):
		grid_tile_size = new_grid_tile_size
		half_grid_tile_size = grid_tile_size / 2
		_on_changed()

@export var mesh: Mesh:
	set(new_mesh):
		mesh = new_mesh
		_on_changed()
  
@export var material: StandardMaterial3D:
	set(new_material):
		material = new_material
		_on_changed()

@export var update: bool:
	set(value):
		_on_changed()

var a_star: AStar3D = null
var used: Array

func get_tile_position(x: int, y: int) -> Vector3:
	var new_position: Vector3 = Vector3(x * grid_tile_size, 0, y * grid_tile_size)
	return new_position

func get_nearest_grid_index(x_pos: float, z_pos: float) -> int:
	var test_position: Vector3 = Vector3(x_pos, 0, z_pos)
	var closest_index: int = a_star.get_closest_point(test_position)
	return closest_index

func get_nearest_grid_point(index: int) -> Vector3:
	return a_star.get_point_position(index)

func _on_changed() -> void:
	if a_star:
		a_star.clear()
	else:
		a_star = AStar3D.new()
	
	if used:
		used.clear()
	else:
		used = []
	
	if selected_grid_mesh_instance:
		selected_grid_mesh_instance.mesh.size.x = grid_tile_size
		selected_grid_mesh_instance.mesh.size.y = grid_tile_size
	
	for child in get_children():
		child.queue_free()
	
	var size: float = grid_dimension * grid_tile_size
	var half_size: float = size / 2
	
	var index: int = 0
	for y_index in grid_dimension:
		for x_index in grid_dimension:
			var mesh_position: Vector3 = get_tile_position(x_index, y_index)
			mesh_position.x -= half_size
			mesh_position.z -= half_size
			
			var mesh_instance: MeshInstance3D = MeshInstance3D.new()
			mesh_instance.position = mesh_position
			mesh_instance.mesh = mesh
			mesh_instance.material_override = material
			add_child(mesh_instance)
			
			a_star.add_point(index, mesh_position)
			used.append(false)
			if (y_index - 1) >= 0:
				a_star.connect_points(index, index - grid_dimension)
			if (x_index - 1) >= 0:
				a_star.connect_points(index, index - 1)
			
			index += 1
