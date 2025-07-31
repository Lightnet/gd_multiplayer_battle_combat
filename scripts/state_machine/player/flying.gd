extends PlayerState
# FLYING

#func enter(_previous_state_path: String, _data := {}) -> void:	
	#pass

#func handle_input(event: InputEvent) -> void:
	#pass

func physics_update(_delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	#print("input_dir: ",input_dir)
	
	var direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	#print("direction: ",direction)
	
	if direction:
		player.velocity.x = (direction.x * player.WALK_SPEED)
		player.velocity.z = (direction.z * player.WALK_SPEED)
	if direction.length() == 0:
			player.velocity = Vector3.ZERO
			
	if Input.is_action_pressed("up"):
		player.velocity.y = (1 * player.WALK_SPEED) * 1
		#pass
	if Input.is_action_pressed("down"):
		player.velocity.y = (1 * player.WALK_SPEED) * -1
		
	player.move_and_slide()
	#pass
