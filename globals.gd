extends Node

signal tick
signal buildings_changed

enum SCENES {MAIN_MENU, WORLD, END_MENU}
var scenes: Array[PackedScene] = [preload("res://menus/main_menu.tscn"),
								preload("res://world.tscn"),
								preload("res://menus/end_menu.tscn")]

var grid: GridVisualizer
var roads: Array = []

var money: int = 100
var total_money: int = money
var max_total_money: int = 500
var total_buildings_money: int = 0:
	set(value):
		total_buildings_money = value
		total_money = money + total_buildings_money

var tick_time: float = 0.5
var current_tick_time: float = tick_time

var current_scene: Node
var current_scene_enum: SCENES
var amount_of_root_scenes: int = 2
var last_amount_of_root_scenes: int = 2

var paused: bool

func _ready():
	current_scene = get_tree().current_scene

func _process(delta: float) -> void:
	amount_of_root_scenes = get_tree().root.get_children().size()
	
	if last_amount_of_root_scenes != amount_of_root_scenes:
		if current_scene_enum == SCENES.WORLD:
			grid = current_scene.get_child(0).get_child(0)
		else:
			grid = null
	
	current_tick_time -= delta
	if current_tick_time <= 0:
		tick.emit()
		current_tick_time = tick_time
		print(money)
		
		if total_money > max_total_money:
			switch_scene(SCENES.END_MENU)
	
	last_amount_of_root_scenes = amount_of_root_scenes

func switch_scene(scene: SCENES) -> void:
	current_scene = scenes[scene].instantiate()
	get_tree().change_scene_to_packed(scenes[scene])
	current_scene_enum = scene

func get_road_from_index(building_index: int) -> int:
	for road in roads:
		for index in road:
			if index == building_index:
				return index
	
	return -1
