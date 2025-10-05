extends Control

@export var master_slider: HSlider
@export var soundtrack_slider: HSlider
@export var sfx_slider: HSlider
var main_menu_scene: String = "res://scenes/menu/main_menu.tscn"

func _enter_tree() -> void:
	master_slider.value = get_bus_volume("Master") * 100
	soundtrack_slider.value = get_bus_volume("Soundtrack") * 100
	sfx_slider.value = get_bus_volume("SFX") * 100

func set_bus_volume(bus_name: String, volume: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	
	if volume == 0.0:
		AudioServer.set_bus_mute(bus_idx, true)
		return
	else:
		AudioServer.set_bus_mute(bus_idx, false)
	
	if volume == 1.0:
		AudioServer.set_bus_volume_db(bus_idx, 0.0)
		return
	
	AudioServer.set_bus_volume_db(bus_idx, -1.0 / volume)

func get_bus_volume(bus_name: String) -> float:
	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	return -1.0 / AudioServer.get_bus_volume_db(bus_idx)

func _on_master_slider_drag_ended(_value_changed: bool) -> void:
	set_bus_volume("Master",  master_slider.value / 100)

func _on_soundtrack_slider_drag_ended(_value_changed: bool) -> void:
	set_bus_volume("Soundtrack",  soundtrack_slider.value / 100)

func _on_sfx_slider_drag_ended(_value_changed: bool) -> void:
	set_bus_volume("SFX",  sfx_slider.value / 100)

func _on_back_button_pressed() -> void:
	SceneTransition.change_scene(main_menu_scene)
