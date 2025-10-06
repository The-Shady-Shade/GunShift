extends Node

var player: Player = null

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	await Talo.players.identify("dev", Talo.players.generate_identifier())
	Talo.events.track("New Entry")
