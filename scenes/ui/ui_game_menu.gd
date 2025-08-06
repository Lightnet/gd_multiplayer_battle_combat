extends Control

@onready var ui_game_menu: Control = $"."

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("game_menu"):
		ui_game_menu.visible = not ui_game_menu.visible
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
