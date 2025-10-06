extends CanvasLayer

@export var animation: AnimationPlayer
@export var process_materials: Array[ParticleProcessMaterial] = []

func _ready() -> void:
	load_particles_cache()

func change_scene(scene: Variant) -> void:
	animation.play("Dissolve")
	await animation.animation_finished
	if scene is PackedScene:
		get_tree().change_scene_to_packed(scene)
	elif scene is String:
		get_tree().change_scene_to_file(scene)
	else:
		push_warning("Scene doesn't exist")
	animation.play_backwards("Dissolve")

func load_particles_cache() -> void:
	for process_material: ParticleProcessMaterial in process_materials:
		var particle: GPUParticles2D = GPUParticles2D.new()
		particle.process_material = process_material
		particle.one_shot = true
		particle.emitting = true
		add_child(particle)
		particle.get_tree().create_timer(0.1).timeout.connect(particle.queue_free)
