extends Button
# refs nope...
@export var next_gui:String
@export var is_delete_gui:bool = true
@export var next_world_2d:String
@export var next_world_3d:String

func _ready() -> void:
	pressed.connect(_on_change_gui)
	#pass

func _on_change_gui():
	if not next_gui.is_empty():
		Global.game_controller.change_gui_scene(next_gui, true)
	if next_gui.is_empty() and is_delete_gui == true:
		Global.game_controller.change_gui_scene(next_gui, true)
	if not next_world_2d.is_empty():
		Global.game_controller.change_2d_scene(next_world_2d)
	if not next_world_3d.is_empty():
		Global.game_controller.change_3d_scene(next_world_3d)
