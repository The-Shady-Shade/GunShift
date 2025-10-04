class_name Enemy extends CharacterBody2D

@export var sprite: Sprite2D
@export var hp: float = 50.0
@export var spd: float = 150.0

func get_damage(dmg: float):
	hp -= dmg
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.8, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
	if hp <= 0.0:
		queue_free()
