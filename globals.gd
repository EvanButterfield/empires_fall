extends Node

signal tick

var money: int

var tick_time: float = 0.5
var current_tick_time: float = tick_time

func _process(delta: float) -> void:
	current_tick_time -= delta
	if current_tick_time <= 0:
		tick.emit()
		current_tick_time = tick_time
		print(money)
		
