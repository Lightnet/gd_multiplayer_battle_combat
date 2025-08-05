extends AudioStreamPlayer

@export var btn_play:Button
@export var btn_stop:Button

func _ready() -> void:
	if btn_play:
		btn_play.pressed.connect(play_audio)
	if btn_stop:
		btn_stop.pressed.connect(stop_audio)
	pass

func _process(delta: float) -> void:
	pass

func play_audio():
	play()
	pass
	
func stop_audio():
	stop()
	pass
