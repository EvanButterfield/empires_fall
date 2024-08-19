class_name Building extends Node3D

@export var building_name: String
@export var cost: int
@export var money_per_tick: int
@export var is_road: bool

var grid_index: int
var road_connections: Array[int]

func init(new_grid_index: int) -> void:
	grid_index = new_grid_index
	Globals.tick.connect(_on_tick)
	Globals.buildings_changed.connect(_on_buildings_changed)

func _on_tick() -> void:
	if money_per_tick == 0:
		return
	
	if road_connections.size() > 0:
		Globals.money += money_per_tick

func _on_buildings_changed() -> void:
	if is_road:
		return
	
	road_connections.clear()
	road_connections.append_array(get_road_connections())
	
	if road_connections.size() > 0:
		$MeshInstance3D.get_surface_override_material(0).albedo_color = Color.GREEN
	else:
		$MeshInstance3D.get_surface_override_material(0).albedo_color = Color.RED

func get_road_connections() -> Array:
	var roads: Array[int]
	var up_building: Building = Globals.grid.get_used(grid_index - Globals.grid.grid_dimension)
	var down_building: Building = Globals.grid.get_used(grid_index + Globals.grid.grid_dimension)
	
	var left_building: Building
	var right_building: Building
	if (grid_index % Globals.grid.grid_dimension) == 0:
		left_building = null
	else:
		left_building = Globals.grid.get_used(grid_index - 1)
	if ((grid_index - (Globals.grid.grid_dimension - 1)) % Globals.grid.grid_dimension) == 0:
		right_building = null
	else:
		right_building = Globals.grid.get_used(grid_index + 1)
	
	if up_building and up_building.is_road:
		roads.append(up_building.grid_index)
	if down_building and down_building.is_road:
		roads.append(down_building.grid_index)
	if left_building and left_building.is_road:
		roads.append(left_building.grid_index)
	if right_building and right_building.is_road:
		roads.append(right_building.grid_index)
	
	return roads
