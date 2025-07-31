extends PlayerState
#prone

@export var HEIGHT_SCALE:float = 0.4
@export var RADIUS_SCALE:float = 0.4

@export var PRONE_SPEED:float = 4.0

func enter(_previous_state_path: String, _data := {}) -> void:
	if player.collision_shape and player.collision_shape.shape is CapsuleShape3D:
		player.collision_shape.shape.set_height( player.original_shape_height * HEIGHT_SCALE)
		player.collision_shape.shape.set_radius( player.original_shape_radius * RADIUS_SCALE)
		
		# adjust position when crouch position update
		var height_difference = (player.original_shape_height - player.collision_shape.shape.height)/2
		player.position.y -= height_difference
	if player.neck:
		player.neck.position.y = player.original_neck_position.y * HEIGHT_SCALE
	print("enter prone")

func exit()->void:
	if player.collision_shape and player.collision_shape.shape is CapsuleShape3D:
		# return shape normal
		player.collision_shape.shape.height = player.original_shape_height
		player.collision_shape.shape.radius = player.original_shape_radius
		# return normal position
		player.position.y = player.original_position_y
	#if player.mesh_instance:
		#player.mesh_instance.position = player.original_mesh_position
	# return normal position
	if player.neck:
		player.neck.position = player.original_neck_position
	print("exit prone")
	#pass
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_released("crouch"):
		finished.emit(IDLE)
	pass

func physics_update(delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	var direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	if direction:
		player.velocity.x = (direction.x * PRONE_SPEED) * delta
		player.velocity.z = (direction.z * PRONE_SPEED) * delta
	if direction.length() == 0:
			player.velocity = Vector3.ZERO
	
	if not player.is_on_floor():
		finished.emit(FALLING)
		
	player.move_and_slide()
	#pass
