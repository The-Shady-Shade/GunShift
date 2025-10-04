class_name Weapon extends Node2D

@onready var player: Player = get_parent()
@export var sprite: Sprite2D
@export var shoot_marker: Marker2D
@export var back_marker: Marker2D
@export var shoot_sfx: AudioStreamPlayer
@export var projectile_scene: PackedScene
var dmg: float = 25.0
var able_to_shoot: bool = true

func _ready() -> void:
	WeaponManager.new_attachment.connect(match_attachments)

func _physics_process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if mouse_position.x > player.global_position.x:
		position.x = abs(position.x)
		scale.y = abs(scale.y)
	elif mouse_position.x < player.global_position.x:
		position.x = -abs(position.x)
		scale.y = -abs(scale.y)
	
	look_at(mouse_position)
	
	if Input.is_action_just_pressed("shoot") && able_to_shoot:
		var projectile: Projectile = projectile_scene.instantiate()
		projectile.global_position = shoot_marker.global_position
		projectile.global_rotation = global_rotation
		projectile.dir = (shoot_marker.global_position - back_marker.global_position).normalized()
		projectile.dmg = dmg
		get_tree().current_scene.add_child(projectile)
		
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.1).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(sprite, "scale", Vector2(0.8, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
		
		shoot_sfx.pitch_scale = randf_range(0.9, 1.1)
		shoot_sfx.play()

func match_attachments() -> void:
	for attachment: String in WeaponManager.weapon_attachments:
		match attachment:
			"TripleBarrel":
				pass
			"ExplosiveBullet":
				pass
