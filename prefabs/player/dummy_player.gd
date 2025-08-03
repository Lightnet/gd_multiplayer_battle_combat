extends CharacterBody3D
class_name Player

@export var stats_data:StatsData


const DUMMY_BOX = preload("res://prefabs/dummy_box/dummy_box.tscn")
const DUMMY_SMALL_BOX = preload("res://prefabs/dummy_small_box/dummy_small_box.tscn")
const DUMMY_BULLET = preload("res://prefabs/dummy_bullet/dummy_bullet.tscn")

#@export_category("Player")
@onready var camera = $Neck/Camera3D
@onready var fire_point: MeshInstance3D = $Neck/Camera3D/MeshInstance3D

@export var speed = 8.0
@export var acceleration = 5.0
@export var jump_speed = 8.0
@onready var spring_arm = $Neck

#@export var spawn_position:Vector3

var mouse_captured: bool = false
var id:String
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim
var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var jumping = false
@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

func _enter_tree():
	#print("get_unique_id:>> ",multiplayer.get_unique_id())
	# assign id for better snyc
	set_multiplayer_authority(name.to_int())
	#if spawn_position:
		#await get_tree().create_timer(0.5).timeout
		#print("spawn_position: ", spawn_position)
		##position = spawn_position
		#global_position = spawn_position
	#if not id.is_empty():
		#set_multiplayer_authority(id.to_int())
	pass
	
func _ready():
	if not stats_data:
		stats_data = StatsData.new()
	if not is_multiplayer_authority(): return
	#print("is_multiplayer_authority():", is_multiplayer_authority())
	camera.current = true
	capture_mouse()
	#if spawn_position:
		#await get_tree().create_timer(0.5).timeout
		#print("name:",name,"spawn_position: ", spawn_position)
		##position = spawn_position
		#global_position = spawn_position
	#pass

func _unhandled_input(event: InputEvent) -> void:
	#print("event mo?")
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("jump"): jumping = true
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#if Input.is_action_just_pressed("primaryfire"):
		#test_fire.rpc()
		#pass
	
func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		#print("mo?")
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("primaryfire"):
		fire_projectile.rpc(multiplayer.get_unique_id())
		#pass
	pass

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	#global_position = spawn_position
	if mouse_captured: _handle_joypad_camera_rotation(delta)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	#velocity.y += -gravity * delta
	#get_move_input(delta)
	move_and_slide()

func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy
	
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
func _rotate_camera(sens_mod: float = 1.0) -> void:
	#print("rotate camera?")
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("left", "right", "forward", "backward")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	#this for lerp movement which we do not want when start walk to speed up 
	#walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	#return walk_vel
	#this should more easy to move
	walk_vel = (walk_dir * speed * move_dir.length()) * delta * 20
	return walk_vel
	
func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel
	
#@rpc("any_peer","call_remote") #nope
#@rpc("call_local")#nope
@rpc("call_local") #okay
func fire_projectile(pid:int):
	#push_error("is_server: " , multiplayer.is_server() , " FIRE ")
	#print("fire test...")
	var dummy_box = DUMMY_BULLET.instantiate()
	dummy_box.set_multiplayer_authority(pid)
	dummy_box.own_body = self
	
	Global.game_controller.current_3d_scene.add_child(dummy_box)
	await get_tree().create_timer(0.01).timeout #wait for sync
	#dummy_box.set_global_position(Vector3(0.0,2.0,0.0)) #test
	#dummy_box.set_global_position(fire_point.global_position)
	dummy_box.set_transform(fire_point.global_transform)
	if dummy_box.has_method("init_direction"):
		dummy_box.init_direction()
	#pass
	
# Does not work on multiplayer since it object but not recommend to allow which they can inject malice code.  
@rpc("any_peer","call_local") #
func _on_receive_hit(hit_info_data:HitInfoData)->void:
	print("player name id:", name)
	#stats_data.health -= amount
	print("HEALTH: ", stats_data.health)
	#print("player _hit_info_data")
	#if hit_info_data.type == "Physical":
		#stats_data.health -= hit_info_data.amount_points
		#stats_data.health -= amount
		#print("HEALTH: ", stats_data.health)	
	pass
	
# multiplayer for json
@rpc("any_peer","call_local") # 
func _on_receive_hit_json(_data:String)->void:
	
	pass
	
@rpc("any_peer","call_local") # 
func _on_receive_hit_float(amount:float)->void:
	stats_data.health -= amount
	print("HEALTH: ", stats_data.health)
	pass
#
