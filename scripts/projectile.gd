class_name Projectile extends CharacterBody2D

@export var area: Area2D
@export var explosion_scene: PackedScene
@export var dust_scene: PackedScene
var dust_emitted: bool = false
@export var spd: float = 400.0
var shooter: Node2D = null

var dir: Vector2 = Vector2.ZERO
var dmg: float = 40.0
var damaged: bool = false

var bounces_max: int = 0
var bounces: int = 0
var bounced: bool = false

var piercing: bool = false

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	get_tree().create_timer(1.5).timeout.connect(queue_free)

func _physics_process(_delta: float) -> void:
	if dir:
		velocity = dir * spd
		look_at(global_position - dir)
	
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var normal: Vector2 = collision.get_normal()
		
		if bounces_max > 0 && bounces < bounces_max && !bounced:
			dir = (dir - normal * 2 * (dir * normal)).normalized()
			area.set_collision_mask_value(2, true)
			bounces += 1
			bounced = true
		
		if !dust_emitted:
			var dust: ParticlesManager = dust_scene.instantiate()
			dust.global_position = collision.get_position()
			get_tree().current_scene.add_child(dust)
			dust.emit()
			dust_emitted = true
		
		if velocity.length() == 0.0:
			queue_free()
	
	move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy && body == shooter:
		return
	
	if body.has_method("get_damage") && !damaged:
		body.get_damage(dmg)
		damaged = true
	
	if body is TileMapLayer && bounces_max > 0 && bounces < bounces_max && !bounced:
		return
	elif body is Enemy && piercing:
		return
	else:
		queue_free()

func _on_body_exited(_body: Node2D) -> void:
	damaged = false
	bounced = false
