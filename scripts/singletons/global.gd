extends Node

var player: Player = null

func _ready() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	await get_tree().create_timer(1.0).timeout
	await Talo.players.identify("dev", str(rng.seed))
	Talo.events.track("New Entry")
