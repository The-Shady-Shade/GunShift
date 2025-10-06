extends Control

@export var intro_scene: PackedScene
@export var settings_menu_scene: PackedScene

func _on_button_pressed() -> void:
	SceneTransition.change_scene(intro_scene)

func _on_setting_button_pressed() -> void:
	SceneTransition.change_scene(settings_menu_scene)
