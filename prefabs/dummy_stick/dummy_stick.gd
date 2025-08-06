extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_collision_enabled: bool = false
var bodies: Array[Node3D] = [] # Array to track collided bodies
#func _ready() -> void:
	#pass
#func _process(delta: float) -> void:
	#pass

@rpc("any_peer","call_local")
func attack()->void:
	print("play attack animation", animation_player)
	print(" animation is_playing: ", animation_player.is_playing())
	#animation_player.play("attack")
	#if not animation_player.is_playing():
	if animation_player.current_animation != "attack":
		is_collision_enabled = true # Enable collision at animation start
		bodies.clear() # Clear the bodies array at the start of the attack
		animation_player.play("attack")
	#pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("melee body:", body)
	
	if is_collision_enabled and body not in bodies:
		#print("melee body:", body)
		bodies.append(body) # Add body to the array to prevent re-triggering
		print("get_multiplayer_authority: ",get_multiplayer_authority())
		if body.has_method("_on_receive_hit"):
			var hit_info_data = HitInfoData.new()
			hit_info_data.amount_points = 5.0
			#send data to match id
			# body._on_receive_hit.rpc_id(body.get_multiplayer_authority(), hit_info_data)
			body._on_receive_hit(hit_info_data)
		print(bodies)
	#pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_collision_enabled = false # Disable collision when animation ends
		print("attack animation finished, collision reset")
		animation_player.play("idle")
		bodies.clear() # Clear the bodies array when animation ends
	#pass
