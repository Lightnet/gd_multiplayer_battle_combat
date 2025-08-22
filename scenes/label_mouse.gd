extends Label

func _unhandled_input(_event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		text = "Mouse Mode: Visible"
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		text = "Mouse Mode: Captured"
