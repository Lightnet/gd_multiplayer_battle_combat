extends RigidBody3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func init_direction()->void:
	var forward_dir = -global_transform.basis.z.normalized()
	apply_central_impulse(forward_dir * 50)
	continuous_cd = true # Enable CCD for fast movement
