extends Node2D

@export var soundtrack: Node

func _process(_delta: float) -> void:
	var playing: bool = false
	for track: AudioStreamPlayer in soundtrack.get_children():
		if track.playing:
			playing = true
	if !playing:
		soundtrack.get_child(randi_range(0, soundtrack.get_child_count() - 1)).play()
