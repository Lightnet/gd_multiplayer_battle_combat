extends RigidBody3D

var own_body:Node3D
@export var SPEED:float = 5 #50

#func _ready() -> void:
	#pass

#func _process(delta: float) -> void:
	#pass
	
func init_direction()->void:
	var forward_dir = -global_transform.basis.z.normalized()
	apply_central_impulse(forward_dir * SPEED)
	continuous_cd = true # Enable CCD for fast movement

func _on_body_entered(body: Node) -> void:
	print("_on_body_entered hit: ", body)
	#if own_body != _body:
		#on_remove.rpc()
	# _on_receive_hit_float
	
	# working
	#if body.has_method("_on_receive_hit_float"):
		#body._on_receive_hit_float.rpc_id(body.get_multiplayer_authority(), 10.0)
		
	if body.has_method("_on_receive_hit"):
		var hit_info_data = HitInfoData.new()
		hit_info_data.amount_points = 10.0
		#send data to match id
		# body._on_receive_hit.rpc_id(body.get_multiplayer_authority(), hit_info_data)
		body._on_receive_hit(hit_info_data)
		
	#if body is Player:
		#if body.has_method("_on_receive_hit"):
			#var hit_info_data = HitInfoData.new()
			#hit_info_data.amount_points = 10.0
			##send data to match id
			#body._on_receive_hit.rpc_id(body.get_multiplayer_authority(), hit_info_data)
	on_remove.rpc()
	#pass

func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	#print("_on_body_shape_entered hit: ", body)
	#if body is Player:
		#if body.has_method("_on_receive_hit"):
			#var hit_info_data = HitInfoData.new()
			#hit_info_data.amount_points = 50.0
			##send data to match id
			#body._on_receive_hit.rpc_id(body.get_multiplayer_authority(), hit_info_data)
	#on_remove.rpc()
	pass

#func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("_on_area_3d_body_entered hit")
	#print("own_body: ", own_body, " >> " ,  body)
	#if own_body != body:
		#on_remove.rpc()
	#pass

@rpc("call_local")
func on_remove()->void:
	print("bullet queue_free")
	queue_free()
	#pass
