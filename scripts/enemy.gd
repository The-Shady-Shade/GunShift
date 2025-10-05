class_name Enemy extends CharacterBody2D

@onready var player: Player = global.player
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var raycast: RayCast2D
@export var hp_bar: TextureProgressBar
@export var damage_sfx: AudioStreamPlayer
@export var projectile_scene: PackedScene
@export var death_vfx_scene: PackedScene
@export var ending_scene: PackedScene
@export var hp: float = 100.0
@export var weapon_dmg: float = 10.0
@export var attack_cd_max: float = 1.0
var attack_cd: float = 0.0
@export var spd: float = 75.0
@export var boss: bool = false
var dead: bool = false
var shooting: bool = true

func _ready() -> void:
	hp_bar.max_value = hp

func _process(delta: float) -> void:
	hp_bar.value = hp
	
	attack_cd = max(0.0, attack_cd - delta)
	raycast.look_at(player.global_position)
	if shooting && raycast.is_colliding():
		if raycast.get_collider() is Player && attack_cd <= 0.0:
			shoot()

func _physics_process(_delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, spd)
	velocity.y = move_toward(velocity.y, 0.0, spd)
	move_and_slide()

func shoot() -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.dir = (global.player.global_position - global_position).normalized()
	projectile.shooter = self
	projectile.dmg = weapon_dmg
	get_tree().current_scene.add_child(projectile)
	attack_cd = attack_cd_max

func get_damage(dmg: float) -> void:
	if dead:
		return
	
	hp -= dmg
	
	damage_sfx.play()
	sprite.material.set("shader_parameter/flash_modifier", 1.0)
	hp_bar.visible = true
	
	if hp <= 0.0:
		dead = true
		visible = false
		collision_shape.queue_free()
		
		if player.auto_loader:
			player.weapon.ammo = player.weapon.ammo_max
		
		if boss:
			player.camera.shake_screen(8, 0.25)
			SceneTransition.change_scene(ending_scene)
		else:
			player.camera.shake_screen(3, 0.1)
		
		var death_vfx: ParticlesManager = death_vfx_scene.instantiate()
		death_vfx.global_position = global_position
		get_tree().current_scene.add_child(death_vfx)
		death_vfx.emit()
		
		await damage_sfx.finished
		queue_free()
		return
	
	var tween: Tween = get_tree().create_tween()
	match weapon_dmg:
		10.0:
			tween.tween_property(sprite, "scale", Vector2(0.8, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
		25.0:
			tween.tween_property(sprite, "scale", Vector2(1.8, 2.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(sprite, "scale", Vector2(2.0, 2.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
		75.0:
			tween.tween_property(sprite, "scale", Vector2(4.8, 5.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
			tween.tween_property(sprite, "scale", Vector2(5.0, 5.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	sprite.material.set("shader_parameter/flash_modifier", 0.0)
	hp_bar.visible = false
