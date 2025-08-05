extends Control

const UI_NOTIFY_MESSAGE = preload("res://ui/ui_notify_message.tscn")
@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_btn_add_pressed() -> void:
	var message = UI_NOTIFY_MESSAGE.instantiate()
	v_box_container.add_child(message)
	message.show_notification("test")
	
	
	#pass
