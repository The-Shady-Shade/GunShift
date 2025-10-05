class_name Weapon extends Node2D

@onready var player: Player = get_parent()
@export var sprite: Sprite2D
@export var shoot_marker: Marker2D
@export var back_marker: Marker2D
@export var shoot_area: Area2D
@export var shoot_sfx: AudioStreamPlayer
@export var projectile_scene: PackedScene

@export_category("Weapon Stats")
@export var ammo_container: VBoxContainer
@export var ammo_max: int = 3
var ammo: int = ammo_max
@export var reload_bar: TextureProgressBar
@export var reload_time_max: float = 1.0
var reload_time: float = 0.0
@export var shoot_bar: TextureProgressBar
@export var shoot_cd_max: float = 0.25
var shoot_cd: float = 0.0
var dmg: float = 40.0
var able_to_shoot: bool = true
@export_category("Weapon Attachments")
@export var burst_shots_max: int = 0
var burst_shots: int = 0
var bursting: bool = false
@export var spray: bool = false
@export var bounces_max: int = 0
@export var piercing_bullets: bool = false

func _ready() -> void:
	reload_bar.max_value = reload_time_max
	shoot_bar.max_value = shoot_cd_max

func _process(delta: float) -> void:
	for ammo_bar: TextureProgressBar in ammo_container.get_children():
		ammo_bar.value = ammo
	reload_bar.value = reload_time
	shoot_bar.value = shoot_cd
	
	if ammo <= 0:
		reload_time += delta
		reload_bar.visible = true
		if reload_time >= reload_time_max:
			ammo = ammo_max
	else:
		reload_time = 0.0
		reload_bar.visible = false
	
	if shoot_cd > 0.0 && shoot_cd < shoot_cd_max:
		shoot_cd += delta
		if shoot_cd_max > 0.25:
			shoot_bar.visible = true
	else:
		shoot_cd = 0.0
		shoot_bar.visible = false

func _physics_process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if mouse_position.x > player.global_position.x:
		position.x = abs(position.x)
		scale.y = abs(scale.y)
	elif mouse_position.x < player.global_position.x:
		position.x = -abs(position.x)
		scale.y = -abs(scale.y)
	
	look_at(mouse_position)
	
	if shoot_area.has_overlapping_bodies():
		able_to_shoot = false
	else:
		able_to_shoot = true
	
	if shoot_cd == 0.0 && able_to_shoot && ammo > 0 && reload_time == 0.0:
		if spray:
			if Input.is_action_pressed("shoot"):
				if burst_shots_max > 0 && !bursting:
					while burst_shots < burst_shots_max:
						shoot()
						burst_shots += 1
						bursting = true
						await get_tree().create_timer(0.1).timeout
					if burst_shots >= burst_shots_max:
						burst_shots = 0
						bursting = false
						shoot_cd += 0.01
				else:
					shoot()
		else:
			if Input.is_action_just_pressed("shoot"):
				if burst_shots_max > 0 && !bursting:
					while burst_shots < burst_shots_max:
						shoot()
						burst_shots += 1
						bursting = true
						await get_tree().create_timer(0.1).timeout
					if burst_shots >= burst_shots_max:
						burst_shots = 0
						bursting = false
						shoot_cd += 0.01
				else:
					shoot()

func shoot() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_position = shoot_marker.global_position
	projectile.global_rotation = global_rotation
	projectile.dir = (shoot_marker.global_position - back_marker.global_position).normalized()
	projectile.shooter = self
	projectile.dmg = dmg
	projectile.bounces_max = bounces_max
	projectile.piercing = piercing_bullets
	get_tree().current_scene.add_child(projectile)
	
	ammo -= 1
	if ammo <= 0 && player.terrified_dash:
		player.dash(true)
	
	shoot_cd += 0.01
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(sprite, "scale", Vector2(0.8, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
	shoot_sfx.pitch_scale = randf_range(0.9, 1.1)
	shoot_sfx.play()
