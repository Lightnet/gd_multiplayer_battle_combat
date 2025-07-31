extends Node
class_name GameController

@export var world_3d:Node3D
@export var world_2d:Node2D
@export var gui:CanvasLayer

@export var current_3d_scene:Node3D
@export var current_2d_scene:Node2D
@export var current_gui_scene:Control

## assign game controller to Global
func _ready() -> void:
	Global.game_controller = self
	#current_gui_scene = $GUI/SplashScreenManager
	#pass

## change gui which required Control class
@rpc("call_local", "reliable")
func change_gui_scene(new_scene:String, delete:bool = true, keep_running:bool = false)->void:
	if current_gui_scene != null:
		if delete:
			#print("gui delete?")
			current_gui_scene.queue_free() #remove node entirely
		elif keep_running:
			current_gui_scene.visible = false #keeps in memory and running
		else:
			gui.remove_child(current_gui_scene) #keeps in memeory, does not run
	#print("gui new_scene.length(): ", new_scene.length())
	if new_scene and not new_scene.is_empty() and new_scene.length() > 0:
		var new = load(new_scene).instantiate()
		gui.add_child(new)
		current_gui_scene = new
	pass

## change scene 2d  required Node2D class
@rpc("call_local", "reliable")
func change_2d_scene(new_scene:String, delete:bool = true, keep_running:bool = false)->void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free() #remove node entirely
		elif keep_running:
			current_2d_scene.visible = false #keeps in memory and running
		else:
			world_2d.remove_child(current_2d_scene) #keeps in memory, does not run
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new
	#pass

## change scene 3d required Node3D class
@rpc("call_local", "reliable")
func change_3d_scene(new_scene:String, delete:bool = true, keep_running:bool = false)->void:
	# print("current_3d_scene: ",current_3d_scene)
	if current_3d_scene:
		if delete:
			# print("scene3d delete?")
			current_3d_scene.queue_free() #remove node entirely
		elif keep_running:
			current_3d_scene.visible = false #keeps in memory and running
		else:
			world_3d.remove_child(current_3d_scene) #keeps in memory, does not run
	#print("new_3d_scene: ",new_scene)
	var new = load(new_scene).instantiate()
	world_3d.add_child(new)
	current_3d_scene = new
	#pass

## change scene to open world
@rpc("call_local", "reliable")
func change_3d_open_world()->void:
	change_3d_scene(Global.open_world_scene_path)
	#pass
#
