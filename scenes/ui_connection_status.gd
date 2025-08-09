extends Control

@onready var label_2: Label = $CenterContainer/VBoxContainer/HBoxContainer/Label_TimeOut

var  is_start:bool = false
var time:float = 0.0

func _process(delta: float) -> void:
	if is_start:
		time += delta
		#label_2.text = str(time)
		label_2.text = "%05.2f" % time  # Format time as 00.00
	#pass

# detect change on visible
func _on_visibility_changed() -> void:
	#print("visible: ", visible)
	if visible:
		time = 0.0
		is_start = true
	#pass
