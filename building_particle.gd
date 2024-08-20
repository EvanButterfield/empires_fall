extends GPUParticles3D

func _ready():
	emitting = true

func _process(delta: float) -> void:
	if emitting == false:
		queue_free()
