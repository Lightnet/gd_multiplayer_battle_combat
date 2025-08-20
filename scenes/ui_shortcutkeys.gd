extends PanelContainer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("f1"):
		if visible == true:
			visible = false
		else:
			visible = true
	pass
