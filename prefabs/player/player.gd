#class_name Player 
extends CharacterBody3D

# Signals
signal toggle_inventory()
signal hit_received(hit_info: HitInfoData)  # Emitted when entity is hit (damage or healing)
signal health_changed(new_health: int, old_health: int)  # Emitted when health changes
signal died()  # Emitted when health reaches zero

# invincible 
# invulnerable
@export var is_invulnerable:bool = false

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var interact_ray: RayCast3D = $Neck/Camera3D/RayCast3D

@export var inventory_data:InventoryData
@export var equip_inventory_data:InventoryDataEquip

@export var stats:StatsData

@export var WALK_SPEED := 5.0
@export var SPRINT_SPEED = 8.0

@export var JUMP_VELOCITY := 4.0
@export var GRAVITY := 9.8
@export var GRAVITY_FALL := 0.9
@export var AIR_CONTROL_SPEED := 5.0
@export var is_controller: = true # handle when the menu N/A
@export var CROUCH_HEIGHT_SCALE = 0.5
@export var CROUCH_RADIUS_SCALE = 0.8
@export var CROUCH_SPEED = 2.5 
@export var is_climbing:bool = false

# Stored original properties
var original_shape_height: float
var original_shape_radius: float
var original_mesh_position: Vector3
var original_neck_position: Vector3
var original_position_y: float

#@onready var draw_3d: Node = $draw3d
@export var statemachine:Node

var wall_normal:Vector3

var obstacles:Array

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Console.add_command("hello", console_hello)
	Console.add_command("fly", console_fly)
	Console.add_command("ghost", console_ghost)
	Console.add_command("walk", console_walk)
	Console.add_command("god", console_god)
	#print("FORWARD: ", Vector3.FORWARD)
	store_data()
# drop item forward position
func get_drop_position() -> Vector3:
	var direction  = -camera.global_transform.basis.z
	return camera.global_position + direction
	#pass
# interact raycast object for chest inventory
func interact() -> void:
	if interact_ray.is_colliding():
		print("interact with ", interact_ray.get_collider())
		var collider = interact_ray.get_collider()
		if collider.has_method("player_interact"):
			collider.player_interact(self)
		#pass
	#pass

func store_data():
	if collision_shape and collision_shape.shape is CapsuleShape3D:
		original_shape_height = collision_shape.shape.height
		original_shape_radius = collision_shape.shape.radius
		print("Original height:", original_shape_height, "Original radius:", original_shape_radius)
	else:
		push_error("CollisionShape3D must have a CapsuleShape3D assigned.")
	if mesh_instance:
		original_mesh_position = mesh_instance.position
	else:
		push_error("MeshInstance3D not found.")
	if neck:
		original_neck_position = neck.position
	original_position_y = position.y
	#pass

func _exit_tree() -> void:
	Console.remove_command("hello")
	
func _input(event: InputEvent) -> void:
	# camera handle for all state.
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(80), deg_to_rad(90))
			
	if event.is_action_pressed("escape"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		
	if Input.is_action_just_pressed("interact"):
		interact()		
		#pass

func _physics_process(delta: float) -> void:
	vaulting(delta)
	#pass

# calculting the place_to_land position and initiating the vault animation.
func vaulting(_delta):
	if Input.is_action_just_pressed("jump"):
		# need to fixed error since detect move when not looking at the area
		#var from  = camera.transform.origin
		var from  = camera.global_position
		var to = camera.to_global(Vector3(0,0,-1))
		#draw_3d.line(from, to)
		#print("from:", from, " to:", to)
		var start_hit = raycast(from, to)
		#print("start_hit: ", start_hit)
		if start_hit and obstacles.is_empty():
			
			#draw_3d.point(start_hit.position, 0.1, Color.RED)
			
			#RayCast to detect the prefect place to land(Not that speical, I just excaggerate :D)
			#from = start_hit.position + self.to_global(Vector3.FORWARD) * collision_shape.shape.radius + (Vector3.UP * collision_shape.shape.height)
			#var forward = -(camera.transform.basis.z.normalized())#nope
			
			# local
			var forward = (transform.basis.z.normalized()) * -1 #correct forward from player root
			#print("forward:", forward)
			
			# start from top to point to ground
			# current ray cast poition + (player forward direction * player shape radius) + (Up * player shape height)
			from = start_hit.position + (forward * collision_shape.shape.radius) + (Vector3.UP * collision_shape.shape.height)
			
			#to = Vector3.DOWN * (collision_shape.shape.height)
			to = start_hit.position + (Vector3.DOWN * (collision_shape.shape.height))
			#ref debug draw
			#draw_3d.line(from, to, Color.RED)
			var place_to_land = raycast(from, to)
			#var place_to_land = raycast(\
				#start_hit.position + self.to_global(Vector3.FORWARD) * collision_shape.shape.radius + (Vector3.UP * collision_shape.shape.height), \
				#Vector3.DOWN * (collision_shape.shape.height))
			if place_to_land:
				vault_animation(place_to_land)
	#pass

# create raycast from visual code
func raycast(from:Vector3, to:Vector3):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to, 2) #layer collision
	query.collide_with_areas = true
	return space.intersect_ray(query)
	#pass

# obstacles for top
func _on_obstacle_detector_top_body_entered(body: Node3D) -> void:
	if body != self:
		obstacles.append(body)
	#pass
	
# obstacles for top
func _on_obstacle_detector_top_body_exited(body: Node3D) -> void:
	if body != self:
		obstacles.remove_at(obstacles.find(body))
	#pass
	
# animation for vulting / climbing
func vault_animation(place_to_land):
	# player is climbing
	is_climbing = true
	
	# first tween animation will make the player move up
	var vertical_climb = Vector3(global_transform.origin.x, place_to_land.position.y, global_transform.origin.z)
	#print("vertical_climb: ", vertical_climb)
	# player set ground with different in player capsule( center orign ) height by half.
	vertical_climb.y = vertical_climb.y + (collision_shape.shape.height / 2)
	var vertical_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	vertical_tween.tween_property(self, "global_transform:origin", vertical_climb, 0.4)
	
	# we wait for the animation to finish
	await vertical_tween.finished
	
	# second tween animation will make the player move forard where the place is facing
	var forward = global_transform.origin + (-self.basis.z * 1.2)
	var forward_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	forward_tween.tween_property(self, "global_transform:origin", forward, 0.3)
	
	# we wait for the animation to finish
	await forward_tween.finished
	
	# player isn't climb anymore
	is_climbing = false
	#pass
#

## dev access
func console_hello():
	Console.print_line("Hello There")
	print("Hello")

func console_fly():
	var state = statemachine.state
	state.finished.emit((state.FLYING))
	Console.print_line("FLY MODE")
	#pass

func console_ghost():
	var state = statemachine.state
	state.finished.emit((state.GHOST))
	Console.print_line("GHOST MODE")
	#pass
	
func console_walk():
	var state = statemachine.state
	state.finished.emit((state.IDLE))
	Console.print_line("NORMAL MODE")
	#pass
	
func console_god():
	#is_invulnerable=true
	is_invulnerable = not is_invulnerable
	if is_invulnerable:
		Console.print_line("GOD MODE: ON")
	else:
		Console.print_line("GOD MODE: OFF")
	#pass

func disable_controller()->void:
	is_controller = false
	#camera.dis
	#pass
func enable_controller()->void:
	is_controller = true
	camera.make_current()

func enter_vehicle_hide()->void:
	is_controller=false
	visible = false
	set_process_input(false)
	set_physics_process(false)
	set_process_input(false)
	#pass

func exit_vehicle_show()->void:
	is_controller=true
	visible = true
	set_process_input(true)
	set_physics_process(true)
	set_process_input(true)
	camera.make_current()
	#pass

# for area3d
func enter_ladder():
	var state = statemachine.state
	state.finished.emit(state.LADDER)
	#pass
	
# for area3d
func enter_idle():
	var state = statemachine.state
	state.finished.emit(state.IDLE)
	#pass

func set_wall_normal(norm:Vector3):
	wall_normal = norm
	
#func get_wall_normal() -> Vector3:
	#return wall_normal

func _on_hit_received(hit_info:HitInfoData):
	if is_invulnerable:
		return
		
	if stats:
		var old_health: float = stats.health
		if hit_info.type == "Heal":
			stats.health += hit_info.amount_point
			if stats.health > stats.health_max:
				stats.health = stats.health_max
			return
		stats.health -= hit_info.amount_point
		print("stats.health: ", stats.health)
		if stats.health < 0:
			stats.health = 0
			emit_signal("died")
		var current_health_points: float = stats.health
		emit_signal("health_changed", current_health_points, old_health)
		

#func on_damage(dmg_type:DamageData):
	#if stats:
		#if dmg_type.type == "Heal":
			#stats.health += dmg_type.damage
			#if stats.health > stats.health_max:
				#stats.health = stats.health_max
			#return
		#stats.health -= dmg_type.damage
		#print("stats.health: ", stats.health)
		#
		#if stats.health < 0:
			#stats.health = 0
		#pass
	#pass
