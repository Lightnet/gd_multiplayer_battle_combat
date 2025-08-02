extends RigidBody3D

var own_body:Node3D

#func _ready() -> void:
	#pass

#func _process(delta: float) -> void:
	#pass
	
func init_direction()->void:
	var forward_dir = -global_transform.basis.z.normalized()
	apply_central_impulse(forward_dir * 50)
	continuous_cd = true # Enable CCD for fast movement

func _on_body_entered(_body: Node) -> void:
	print("_on_body_entered hit")
	if own_body != _body:
		on_remove.rpc()
	#on_remove.rpc()
	#pass

func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	print("_on_body_shape_entered hit")
	#if own_body != _body:
		#on_remove.rpc()
	on_remove.rpc()
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
