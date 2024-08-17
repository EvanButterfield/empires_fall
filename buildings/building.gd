class_name Building extends Node3D

@export var building_name: String
@export var cost: int
@export var money_per_tick: int
@export var is_road: bool

var grid_index: int
var road_connections: Array[int] = []

func init(new_grid_index: int) -> void:
	grid_index = new_grid_index
	Globals.tick.connect(_on_tick)
	
	if !is_road:
		Globals.buildings_changed.connect(_on_buildings_changed)

func _on_tick() -> void:
	if money_per_tick == 0:
		return
	
	if road_connections.size() > 0:
		Globals.money += money_per_tick

func _on_buildings_changed() -> void:
	road_connections.clear()
	
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
		road_connections.append(grid_index - Globals.grid.grid_dimension)
	if down_building and down_building.is_road:
		road_connections.append(grid_index + Globals.grid.grid_dimension)
	if left_building and left_building.is_road:
		road_connections.append(grid_index - 1)
	if right_building and right_building.is_road:
		road_connections.append(grid_index + 1)
	
	if road_connections.size() > 0:
		$MeshInstance3D.get_surface_override_material(0).albedo_color = Color.GREEN
	else:
		$MeshInstance3D.get_surface_override_material(0).albedo_color = Color.RED
