extends PlayerState
#wall running
var SPEED = 5.0
var wall_normal
var is_wall_runable:bool = false
var direction:Vector3
@onready var time_wall_run: Timer = $time_wall_run
#var time_wall_run

#func _ready() -> void:# error not load correct
	##time_wall_run =get_tree().create_timer(2.0) # if created it will null character3d
	#time_wall_run = Timer.new()
	#time_wall_run.wait_time = 2.0
	#time_wall_run.timeout.connect(_on_time_wall_run)
	#add_child(time_wall_run)
	#pass

func enter(_previous_state_path: String, _data := {}) -> void:
	#wall_normal = player.get_wall_normal()
	#print("wall_normal:",player.wall_normal)
	#wall_normal = player.get_slide_collision(0)
	is_wall_runable = true
	time_wall_run.start()
	pass

func handle_input(_event: InputEvent) -> void:
	
	pass

func physics_update(_delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward",-1.0)
	#print("input_dir: ",input_dir)
	
	direction = (player.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	
	if direction:
		player.velocity.x = direction.x * player.WALK_SPEED
		player.velocity.z = direction.z * player.WALK_SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.WALK_SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.WALK_SPEED)
		
	print("player.wall_normal: ", player.get_wall_normal())
	if is_wall_runable:
		wall_normal = player.get_wall_normal()
		#await get_tree().create_timer(0.2).timeout
		player.velocity.y = 0
		direction = -wall_normal * SPEED
		
	#if move away from the wall start fall
	if not player.is_on_wall():
		is_wall_runable = false
		finished.emit(FALLING)
	player.move_and_slide()
	pass

func _on_time_wall_run_timeout() -> void:
	is_wall_runable = false
	finished.emit(FALLING)
	#pass
