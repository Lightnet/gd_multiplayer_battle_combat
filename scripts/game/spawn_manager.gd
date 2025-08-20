extends Node

@export var spawnpoints:Array[Node3D]

func get_spawns()-> Array[Node3D]:
	return spawnpoints

func random_spawn() -> Vector3:
	if spawnpoints.is_empty():
		return Vector3.ZERO
	return spawnpoints[randi() % spawnpoints.size()].global_position
