extends Control

@onready var attachment_menu: Control = get_parent().get_parent()
@export var name_label: RichTextLabel
@export var description_label: RichTextLabel
@export var button: Button
@export var attach_sfx: AudioStreamPlayer

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	AttachmentsManager.attach(name_label.text.trim_prefix("[center]"))
	get_tree().paused = false
	attach_sfx.play()
	attachment_menu.animation.play_backwards("Blur")
	attachment_menu.visible = false
	await attach_sfx.finished
	attachment_menu.queue_free()
