@tool
class_name Grid extends Node3D

@export var grid_dimension: int = 2:
	set(new_grid_dimension):
		grid_dimension = new_grid_dimension
		_on_changed()

@export var grid_tile_size: float = 0.5:
	set(new_grid_tile_size):
		grid_tile_size = new_grid_tile_size
		_on_changed()

@export var mesh: Mesh:
	set(new_mesh):
		if mesh:
			mesh.free()
		
		mesh = new_mesh
		_on_changed()
  
@export var material: StandardMaterial3D:
	set(new_material):
		if material:
			material.free()
		
		material = new_material
		_on_changed()

func get_tile_position(x: int, y: int) -> Vector3:
	var new_position: Vector3 = Vector3(x * grid_tile_size, 0, y * grid_tile_size)
	return new_position

func _on_changed() -> void:
	for child in get_children():
		child.queue_free()
	
	var size: float = grid_dimension * grid_tile_size
	var half_size: float = size / 2
	
	for y_index in grid_dimension:
		for x_index in grid_dimension:
			var mesh_position: Vector3 = get_tile_position(x_index, y_index)
			mesh_position.x -= half_size
			mesh_position.z -= half_size
			
			var mesh_instance: MeshInstance3D = MeshInstance3D.new()
			mesh_instance.position = mesh_position
			mesh_instance.mesh = mesh
			mesh_instance.set_surface_override_material(0, material)
			add_child(mesh_instance)
