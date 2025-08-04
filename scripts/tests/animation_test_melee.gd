extends Node3D

@onready var dummy_stick: Node3D = $DummyStick

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("slot1"):
		dummy_stick.attack()
	pass

#func _ready() -> void:
	#pass

#func _process(delta: float) -> void:
	#pass
