extends Camera2D

var shake_intensity: float = 0.0
var active_shake_time: float = 0.0
var shake_decay: float = 5.0
var shake_time: float = 0.0
var shake_time_spd: float = 20.0
var noise: FastNoiseLite = FastNoiseLite.new()

func _physics_process(delta: float) -> void:	
	var mouse_position: Vector2 = get_global_mouse_position()
	var mouse_offset: Vector2 = Vector2((mouse_position.x - global_position.x) / (640.0 / 15.0), (mouse_position.y - global_position.y) / (360.0 / 15.0))
	
	if active_shake_time > 0.0:
		shake_time += delta * shake_time_spd
		active_shake_time -= delta
		offset = Vector2(noise.get_noise_2d(shake_time, 0.0) * shake_intensity, noise.get_noise_2d(0.0, shake_intensity) * shake_intensity) + mouse_offset
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		offset = lerp(offset, mouse_offset, 10.5 * delta) 

func shake_screen(intensity: int, time: float) -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0
