extends PanelContainer

@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var timer: Timer = $Timer
var tween: Tween
var fade_int:float = 0.5
var message_duration:float = 2.0
var fade_out:float = 0.5

func _ready() -> void:
	# Initialize the label as invisible
	#label.modulate.a = 0  # Set alpha to 0 (fully transparent)
	modulate.a = 0
	pass

#func _process(delta: float) -> void:
	#pass

#func set_status_icon(index:int):
	#pass

func show_notification(msg:String, duration: float = 2.0):
	label.text = msg
	# Reset label transparency
	#label.modulate.a = 0
	modulate.a = 0
	
	 # Create a new Tween
	if tween:
		tween.kill()  # Stop any existing tween
	tween = create_tween()
	
	# Fade in animation
	#tween.tween_property(label, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 1.0, fade_int).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	await get_tree().create_timer(message_duration).timeout
	tween = create_tween()
	
	tween.tween_property(self, "modulate:a", 0.0, fade_out).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished # This pauses execution until the tween is done
	remove_notify()
	
	# Start the timer to wait before fading out
	#timer.start(duration)
	#pass

func _on_timer_timeout() -> void:
	# Create a new Tween for fade out
	#if tween:
		#tween.kill()
	#tween = create_tween()
	
	# Fade out animation
	#tween.tween_property(label, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(self, "modulate:a", 0.0, fade_out).set_ease(Tween.EASE_IN_OUT)
	
	#await tween.finished # This pauses execution until the tween is done
	#remove_notify()
	
	
	# Queue free after the tween finishes
	#tween.tween_callback(remove_notify) # does not work
	#queue_free()
	pass
	
func remove_notify()->void:
	print("queue_free notify")
	queue_free()
	pass

func _on_btn_close_pressed() -> void:
	remove_notify()
	#pass
