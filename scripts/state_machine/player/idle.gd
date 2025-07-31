extends PlayerState
# IDLE

#func enter(previous_state_path: String, data := {}) -> void:
	#player.velocity.x = 0.0
	#player.velocity.y = 0.0
	#player.velocity.z = 0.0
	#player.animation_player.play("idle")
	#pass

#func handle_input(event: InputEvent) -> void:
	#print("event:", event)
	#if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#if event is InputEventMouseMotion:
			#player.rotate_y(-event.relative.x * 0.01)
			#player.camera.rotate_x(-event.relative.y * 0.01)
			#player.camera.rotation.x = clampf(player.camera.rotation.x, -deg_to_rad(80), deg_to_rad(90))
	#if Input.is_action_just_pressed("forward") or Input.is_action_just_pressed("backward"):
		#finished.emit(RUNNING)
	#elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		#finished.emit(RUNNING)
	#elif Input.is_action_pressed("jump"):
		#finished.emit(JUMPING)
	#pass

func physics_update(_delta: float) -> void:
	#print("idle: ", player.is_on_floor())
	#if !player.is_on_floor():
		#player.velocity.y += (player.GRAVITY * -1) * _delta
		#player.velocity.y += (player.GRAVITY * player.get_gravity().y) * delta
		#player.velocity.y += (player.get_gravity().y * player.GRAVITY_FALL) * delta
		#print("GRAVITY???")
		#pass
	#player.move_and_slide()
	
	if not PlayerManager.is_enable_controller():
		return
	#await get_tree().create_timer(0.2)

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("forward") or Input.is_action_just_pressed("backward") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		finished.emit(WALKING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(CROUCHING)
	elif Input.is_action_just_pressed("prone"):
		finished.emit(PRONE)
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMPING)
	elif player.velocity.length() > 0:
		finished.emit(RUNNING)
