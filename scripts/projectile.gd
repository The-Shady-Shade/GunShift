class_name Projectile extends CharacterBody2D

@export var spd: float = 400.0
var dmg: float = 25.0
var dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(_delta: float) -> void:
	if dir:
		velocity = dir * spd
	
	for i: int in get_slide_collision_count():
		var collider: Node2D = get_slide_collision(i).get_collider()
		if collider.has_method("get_damange"):
			collider.get_damage(dmg)
		queue_free()
	
	move_and_slide()
