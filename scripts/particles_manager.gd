class_name ParticlesManager extends Node2D

@export var timer: float = 1.0
var emitted: bool = false

func emit() -> void:
	if emitted:
		return
	
	for node: Node in get_children():
		if node is GPUParticles2D:
			node.emitting = true
		elif node is AudioStreamPlayer:
			node.play()
	
	emitted = true
	get_tree().create_timer(timer).timeout.connect(queue_free)
