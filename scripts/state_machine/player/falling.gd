extends PlayerState
# FALLING

#func enter(previous_state_path: String, data := {}) -> void:
	#pass

func physics_update(delta: float) -> void:
	#print("fall > is floor: ", player.is_on_floor())
	#var input_direction_x := Input.get_axis("left", "right")
	#player.velocity.x = player.WALK_SPEED * input_direction_x
	
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	#print("input_dir: ",input_dir)
	
	var direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	#print("direction: ",direction)
	if direction:
		player.velocity.x = (direction.x * player.WALK_SPEED)
		player.velocity.z = (direction.z * player.WALK_SPEED)
	#print("player.get_gravity(): ", player.get_gravity())
	#player.velocity.y += player.GRAVITY * delta
	player.velocity.y += (player.get_gravity().y) * delta
	#player.velocity.y += (player.get_gravity().y * 0.5) * delta
	#print("player.velocity.y: ",player.velocity.y)
	
	#if player.is_on_floor() and isGround == false:
	if player.is_on_floor():
		finished.emit(IDLE)
	if player.velocity.y >= 0:
		finished.emit(FALLING)

	player.move_and_slide()
