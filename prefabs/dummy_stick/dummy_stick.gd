extends Node3D
@onready var area_3d: Area3D = $pivot/Area3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_collision_enabled: bool = false
var bodies: Array[Node3D] = [] # Array to track collided bodies

@rpc("any_peer", "call_local")
func attack() -> void:
	print("play attack animation", animation_player)
	print("animation is_playing: ", animation_player.is_playing())
	
	if animation_player.current_animation != "attack":
		is_collision_enabled = true # Enable collision at animation start
		bodies.clear() # Clear the bodies array at the start of the attack
		
		# Check for bodies already inside the Area3D
		#var area: Area3D = $Area3D # Replace with your Area3D node path
		for body in area_3d.get_overlapping_bodies():
			if body not in bodies and body.has_method("_on_receive_hit"):
				bodies.append(body) # Add body to prevent re-triggering
				var hit_info_data = HitInfoData.new()
				hit_info_data.amount_points = 5.0
				body._on_receive_hit(hit_info_data)
				print("Processed overlapping body: ", body)
		
		animation_player.play("attack")

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("melee body entered: ", body)
	if is_collision_enabled and body not in bodies:
		bodies.append(body) # Add body to the array to prevent re-triggering
		if body.has_method("_on_receive_hit"):
			var hit_info_data = HitInfoData.new()
			hit_info_data.amount_points = 5.0
			body._on_receive_hit(hit_info_data)
		print("Bodies array: ", bodies)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_collision_enabled = false # Disable collision when animation ends
		print("attack animation finished, collision reset")
		
		# Optional: Process remaining bodies for damage at animation end
		for body in bodies:
			if body.has_method("_on_receive_hit"):
				var hit_info_data = HitInfoData.new()
				hit_info_data.amount_points = 5.0 # Adjust damage if needed
				body._on_receive_hit(hit_info_data)
				print("Processed body at animation end: ", body)
		
		bodies.clear() # Clear the bodies array when animation ends
		animation_player.play("idle")

func _on_area_3d_body_exited(body: Node3D) -> void:
	bodies.erase(body)
	print("Body exited: ", body)
