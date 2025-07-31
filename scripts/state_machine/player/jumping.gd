extends PlayerState
# JUMPING

func enter(_previous_state_path: String, _data := {}) -> void:
	#player.animation_player.play("fall")
	player.velocity.y = player.JUMP_VELOCITY
	#player.velocity.y = 10
	#pass

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("left", "right")
	#player.velocity.x = player.WALK_SPEED * input_direction_x
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	#print("input_dir: ",input_dir)
	
	var direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	#print("direction: ",direction)
	
	if direction:
		player.velocity.x = (direction.x * player.WALK_SPEED)
		player.velocity.z = (direction.z * player.WALK_SPEED)
	
	#player.velocity.y += player.GRAVITY * delta
	#player.velocity.y += (player.GRAVITY * player.get_gravity().y) * delta
	player.velocity.y += (player.get_gravity().y * player.GRAVITY_FALL) * delta
	player.move_and_slide()
	
	# if hit wall and space hold to wall run
	if player.is_on_wall() and Input.is_action_pressed("jump"):
		finished.emit(WALLRUNNING)

	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
	elif player.velocity.y <= 0:
		finished.emit(FALLING)
	#print("player.velocity.y: ", player.velocity.y)
