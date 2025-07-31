extends PlayerState
# sliding
# slow down to stop.
# Sliding state with deceleration, downhill acceleration, and speed cap

@export var max_slide_speed: float = 10.0  # Maximum speed when sliding
@export var slide_deceleration: float = 5.0  # Deceleration rate on flat ground (units/sec^2)
@export var downhill_acceleration: float = 8.0  # Acceleration when sliding downhill (units/sec^2)
@export var min_slide_speed: float = 2.0  # Minimum speed to stay in sliding state

var slide_velocity: Vector3 = Vector3.ZERO  # Current sliding velocity

func enter(_previous_state_path: String, _data := {}) -> void:
	# Initialize sliding velocity based on player's current velocity or direction
	slide_velocity = player.velocity
	if slide_velocity.length() == 0:
		# If no velocity, use the player's facing direction
		var input_dir = Input.get_vector("left", "right", "forward", "backward", -1.0)
		var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			slide_velocity = direction * player.SPRINT_SPEED
		else:
			slide_velocity = player.transform.basis.z * player.SPRINT_SPEED  # Default to forward

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("crouch"):
		finished.emit(RUNNING)
	#pass

func physics_update(delta: float) -> void:
	# Get input direction for potential steering (optional)
	var input_dir = Input.get_vector("left", "right", "forward", "backward", -1.0)
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Check if player is on the floor
	if not player.is_on_floor():
		finished.emit(FALLING)
		return
	elif Input.is_action_pressed("jump"):
		finished.emit(JUMPING)
		return
	elif is_equal_approx(input_dir.x, 0.0) and is_equal_approx(input_dir.y, 0.0) and slide_velocity.length() < min_slide_speed:
		finished.emit(IDLE)
		return

	# Get the floor normal to determine slope
	var floor_normal = player.get_floor_normal()
	var slope_angle = acos(floor_normal.dot(Vector3.UP))  # Angle between floor normal and up vector
	var is_downhill = floor_normal.dot(-slide_velocity.normalized()) > 0  # Check if slope is downhill

	# Calculate slope direction (project slide direction onto the plane of the slope)
	var slope_direction = Vector3.ZERO
	if slope_angle > 0.01:  # Avoid division by zero or flat surfaces
		slope_direction = -floor_normal.cross(Vector3.UP).cross(floor_normal).normalized()

	# Apply deceleration on flat ground or slight uphill
	var deceleration = slide_deceleration
	if is_downhill and slope_angle > 0.01:
		# Accelerate downhill based on slope steepness
		var slope_factor = sin(slope_angle)  # Steeper slopes increase acceleration
		slide_velocity += slope_direction * downhill_acceleration * slope_factor * delta
	else:
		# Decelerate on flat ground or uphill
		var speed = slide_velocity.length()
		if speed > 0:
			var deceleration_amount = deceleration * delta
			var new_speed = max(speed - deceleration_amount, 0.0)
			slide_velocity = slide_velocity.normalized() * new_speed

	# Cap the speed
	var current_speed = slide_velocity.length()
	if current_speed > max_slide_speed:
		slide_velocity = slide_velocity.normalized() * max_slide_speed

	# Apply slight steering if there's input (optional)
	if direction:
		# Blend slide velocity toward input direction for slight control
		var steer_strength = 0.5  # Adjust for how much control the player has
		slide_velocity = slide_velocity.lerp(direction * slide_velocity.length(), steer_strength * delta)

	# Apply velocity to the player
	player.velocity = slide_velocity
	player.velocity.y = -0.1  # Small downward force to keep player grounded
	player.move_and_slide()

	# Update slide velocity after movement (to account for collisions)
	slide_velocity = player.velocity
	slide_velocity.y = 0  # Ignore vertical velocity for sliding calculations
	
	if player.velocity.length() == 0:
		finished.emit(CROUCHING)
