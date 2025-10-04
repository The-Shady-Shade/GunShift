extends Node
signal new_attachment

var attachments: Array[String] = []

func attach(attachment: String) -> void:
	attachments.append(attachment)
	new_attachment.emit()
