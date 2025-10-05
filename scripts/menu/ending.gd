extends Control

@export var win_sfx: AudioStreamPlayer
var main_menu_scene: String = "res://scenes/menu/main_menu.tscn"

func _on_back_pressed() -> void:
	SceneTransition.change_scene(main_menu_scene)
