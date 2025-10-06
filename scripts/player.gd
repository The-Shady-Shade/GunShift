class_name Player extends CharacterBody2D

@export var camera: Camera2D
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var weapon: Node2D

@export var hp_bar: TextureProgressBar
@export var dash_bar: TextureProgressBar

@export var dash_sfx: AudioStreamPlayer
@export var damage_sfx: AudioStreamPlayer
@export var death_sfx: AudioStreamPlayer

@export_category("HP")
@export var hp_max: float = 100.0
var hp: float = hp_max
@export_category("Dash")
@export var dash_cd_max: float = 2.0
var dash_cd: float = 0.0
@export var dash_time_max: float = 0.25
var dash_time: float = 0.0
@export var dash_spd: float = 300.0
@export var dash_trail_delay: float = 0.05
var dash_trail_timer: float = 0.0
@export_category("Movement")
@export var spd: float = 150.0
@export_category("Player Attachments")
@export var auto_loader: bool = false
@export var terrified_dash: bool = false
@export var tactical_reload: bool = false
@export var heal: bool = false

func _ready() -> void:
	global.player = self
	hp_bar.max_value = hp_max
	dash_bar.max_value = dash_cd_max

func _process(delta: float) -> void:
	hp = clamp(hp, 0.0, hp_max)
	dash_time = max(0.0, dash_time - delta)
	dash_trail_timer -= delta * 5
	
	if dash_cd > 0.0 && dash_cd < dash_cd_max:
		dash_cd += delta
		dash_bar.visible = true
	else:
		dash_cd = 0.0
		dash_bar.visible = false
	
	hp_bar.value = hp
	dash_bar.value = dash_cd

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if dir:
		if Input.is_action_just_pressed("dash") && dash_time <= 0.0 && dash_cd <= 0.0:
			dash()
			
		if dash_time > 0.0:
			velocity = dir * dash_spd
			if dash_trail_timer < 0.0:
				dash_trail_timer = dash_trail_delay
				emit_dash_trail()
		else:
			velocity = dir * spd
	else:
		velocity.x = move_toward(velocity.x, 0, spd)
		velocity.y = move_toward(velocity.y, 0, spd)
	
	var mouse_position: Vector2 = get_global_mouse_position()
	if mouse_position.x > global_position.x:
		dash_bar.position.x = -18
	elif mouse_position.x < global_position.x:
		dash_bar.position.x = 10
	
	move_and_slide()

func dash(terrified: bool = false) -> void:
	dash_time = dash_time_max
	dash_trail_timer = 0.0
	
	
	
	if !terrified:
		dash_cd += 0.01
	dash_sfx.play()
	
	if tactical_reload:
		weapon.ammo = weapon.ammo_max
	
	if heal:
		hp += hp_max / 5
		hp_bar.visible = true
		await get_tree().create_timer(0.5).timeout
		hp_bar.visible = false

func get_damage(dmg: float) -> void:
	hp -= dmg
	
	if hp <= 0.0:
		if !death_sfx.playing:
			death_sfx.play()
		global.player.camera.shake_screen(6, 0.2)
		AttachmentsManager.attachments = []
		SceneTransition.change_scene(get_tree().current_scene.scene_file_path)
		return
	
	damage_sfx.play()
	global.player.camera.shake_screen(4, 0.1)
	
	var scale_tween: Tween = get_tree().create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2(0.8, 1.2), 0.1).set_trans(Tween.TRANS_BOUNCE)
	scale_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
	hp_bar.visible = true
	await get_tree().create_timer(0.5).timeout
	hp_bar.visible = false

func emit_dash_trail() -> void:
	var trail: Node2D = Node2D.new()
	trail.z_index = -2
	trail.modulate = Color(1.0, 1.0, 1.0, 0.75)
	get_tree().current_scene.add_child(trail)
	trail.global_position = global_position # - Vector2(0, 0.1)
	
	var trail_sprite: Sprite2D = sprite.duplicate()
	trail.add_child(trail_sprite)
	
	var scale_tween: Tween = get_tree().create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2(0.8, 0.8), 0.1).set_trans(Tween.TRANS_BOUNCE)
	scale_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
	var trail_modulate_tween: Tween = create_tween()
	trail_modulate_tween.set_ease(Tween.EASE_OUT)
	trail_modulate_tween.tween_property(trail, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	trail_modulate_tween.chain().tween_callback(trail.queue_free)
