extends PlayerState

#func enter(previous_state_path: String, data := {}) -> void:
	#player.animation_player.play("run")
	#pass

func handle_input(event: InputEvent) -> void:
	#print("forward run")
	if event.is_action_released("sprint"):
		print("input walk")
		finished.emit(WALKING)
	#pass

func physics_update(_delta: float) -> void:
	#print("running...")
	
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	#print("input_dir: ",input_dir)
	
	var direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	#print("direction: ",direction)
	
	if direction:
		player.velocity.x = (direction.x * player.SPRINT_SPEED)
		player.velocity.z = (direction.z * player.SPRINT_SPEED)
	if direction.length() == 0:
			player.velocity = Vector3.ZERO
	
	#var input_direction_x := Input.get_axis("left", "right")
	#var input_direction_y := Input.get_axis("forward", "backward")
	#var forward = -player.get_node("Camera3D").get_global_transform().basis.z.normalized()
	#var right = -player.get_node("Camera3D").get_global_transform().basis.x.normalized()
	##print("input_direction_x: ", input_direction_x, " input_direction_y: ", input_direction_y)
	#var dir = Vector3.ZERO
	#if input_direction_y != 0:
		#if input_direction_y > 0:
			#dir = forward * -1
		#if input_direction_y < 0:
			#dir = forward * 1
			#
	#if input_direction_x != 0:
		#if input_direction_x > 0:
			#dir += right * -1
		#if input_direction_x < 0:
			#dir += right * 1
	#
	#dir = dir * player.speed * delta
	#
	#if input_direction_y == 0 and input_direction_x == 0:
		#player.velocity = Vector3.ZERO
	#player.velocity = dir

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("crouch"):
		finished.emit(SLIDING)
	elif is_equal_approx(input_dir.x, 0.0) and is_equal_approx(input_dir.y, 0.0):
		#print("RUN > IDLE")
		finished.emit(IDLE)
		
	player.move_and_slide()
