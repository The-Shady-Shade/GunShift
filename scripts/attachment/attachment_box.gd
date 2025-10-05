extends Node2D

@export var area: Area2D
@export var pickup_sfx: AudioStreamPlayer
@export var attachment_menu_scene: PackedScene

func _process(_delta: float) -> void:
	if area.has_overlapping_bodies() && visible:
		var attachment_menu: Control = attachment_menu_scene.instantiate()
		global.player.add_child(attachment_menu)
		pickup_sfx.play()
		visible = false
		await pickup_sfx.finished
		queue_free()
