extends PlayerState
#CROUCHING

func enter(_previous_state_path: String, _data := {}) -> void:
	
	if player.collision_shape and player.collision_shape.shape is CapsuleShape3D:
		player.collision_shape.shape.height = player.original_shape_height * player.CROUCH_HEIGHT_SCALE
		player.collision_shape.shape.radius = player.original_shape_radius * player.CROUCH_RADIUS_SCALE
		# adjust position when crouch position update
		var height_difference = (player.original_shape_height - player.collision_shape.shape.height)/2
		player.position.y -= height_difference
	
	#if player.mesh_instance:
		#player.mesh_instance.position.y = player.original_mesh_position.y * player.CROUCH_HEIGHT_SCALE
		
	if player.neck:
		player.neck.position.y = player.original_neck_position.y * player.CROUCH_HEIGHT_SCALE
	pass

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
	pass

func handle_input(event: InputEvent) -> void:
	
	if event.is_action_released("crouch"):
		finished.emit(IDLE)
		#pass
	#pass

func physics_update(_delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	#print("input_dir: ",input_dir)
	
	var direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	#print("direction: ",direction)
	
	if direction:
		player.velocity.x = (direction.x * player.CROUCH_SPEED) 
		player.velocity.z = (direction.z * player.CROUCH_SPEED) 
	if direction.length() == 0:
			player.velocity = Vector3.ZERO
			
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMPING)
		
	player.move_and_slide()
	#pass
