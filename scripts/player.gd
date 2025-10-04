class_name Player extends CharacterBody2D

@export var sprite: Sprite2D
@export var weapon: Node2D
@export var step_sfx: AudioStreamPlayer
@export var spd: float = 150.0

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if dir:
		velocity = dir * spd
		#if !step_sfx.playing:
			#step_sfx.play()
	else:
		velocity.x = move_toward(velocity.x, 0, spd)
		velocity.y = move_toward(velocity.y, 0, spd)
	
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if mouse_position.x > global_position.x:
		sprite.flip_h = false
	elif mouse_position.x < global_position.x:
		sprite.flip_h = true

	move_and_slide()
