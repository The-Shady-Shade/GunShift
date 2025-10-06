extends Control

@export var world_scene: PackedScene
@export var timer: float = 3.0

func _ready() -> void:
	await get_tree().create_timer(timer).timeout
	SceneTransition.change_scene(world_scene)
