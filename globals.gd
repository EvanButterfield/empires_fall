extends Node

signal tick
signal buildings_changed

var grid: GridVisualizer
var roads: Array = []

var money: int = 100

var tick_time: float = 0.5
var current_tick_time: float = tick_time

func _ready():
	grid = get_tree().current_scene.get_child(0).get_child(0)

func _process(delta: float) -> void:
	current_tick_time -= delta
	if current_tick_time <= 0:
		tick.emit()
		current_tick_time = tick_time
		print(money)

func get_road_from_index(building_index: int) -> int:
	for road in roads:
		for index in road:
			if index == building_index:
				return index
	
	return -1
