extends PlayerState
# LADDER

func enter(_previous_state_path: String, _data := {}) -> void:
	
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func physics_update(_delta: float) -> void:
	# Handle movement to side h direction
	var input_dir = Vector3(
		Input.get_axis("left", "right"),
		0,
		Input.get_axis("forward", "backward")
	).normalized()
	#player.velocity.x = input_dir.x * player.WALK_SPEED
	#player.velocity.z = input_dir.z * player.WALK_SPEED
	
	var cam_forward = -player.camera.global_transform.basis.z.normalized()
	if input_dir.length() > 0:
		player.velocity.x = cam_forward.x * player.WALK_SPEED
		player.velocity.z = cam_forward.z * player.WALK_SPEED
	else:
		player.velocity.x = 0
		player.velocity.z = 0
	#print(input_dir.length())
	
	# foward direction for going up or down
	if Input.is_action_pressed("forward"):
		#var cam_forward = -player.camera.global_transform.basis.z.normalized()
		print("cam_forward: " ,cam_forward)
		if cam_forward.y > 0:
			player.velocity.y = 50 * _delta
		else:
			player.velocity.y = 50 * _delta * -1
	else:
		player.velocity.y = 0
		
	# update player physics move
	player.move_and_slide()
	#pass
