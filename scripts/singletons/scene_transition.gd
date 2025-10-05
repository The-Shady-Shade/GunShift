extends CanvasLayer

@export var animation: AnimationPlayer

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
