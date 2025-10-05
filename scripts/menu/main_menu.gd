extends Control

@export var world_scene: PackedScene
@export var settings_menu_scene: PackedScene

func _on_button_pressed() -> void:
	SceneTransition.change_scene(world_scene)

func _on_setting_button_pressed() -> void:
	SceneTransition.change_scene(settings_menu_scene)
