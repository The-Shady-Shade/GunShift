extends Control

@onready var attachments: Dictionary = AttachmentsManager.attachments_list
@export var container: VBoxContainer
@export var animation: AnimationPlayer
@export var attachment_scene: PackedScene
@export var attachments_count: int = 3
var numbers: Array[int] = []

func _ready() -> void:
	get_tree().paused = true
	animation.play("Blur")
	for i: int in attachments_count:
		var attachment: PanelContainer = attachment_scene.instantiate()
		var number: int = randi_range(0, attachments.size() - 1)
		while numbers.has(number) || AttachmentsManager.attachments.has(attachments.keys()[number]):
			number = randi_range(0, attachments.size() - 1)
		numbers.append(number)
		attachment.name_label.text = "[center]" + attachments.keys()[number]
		attachment.description_label.text = "[center]" + attachments[attachments.keys()[number]]
		container.add_child(attachment)
