extends HSlider
# https://www.youtube.com/watch?v=aFkRmtGiZCw
@export var spin_box: SpinBox
@export var bus_name:String
@export var bus_index:int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	if GameData.game_config:
		var volume = GameData.get_name_volume(bus_name)
		if volume:
			print("volume:", volume)
			value = volume
		pass
	
	pass

func _on_value_changed(value:float):
	
	if spin_box:
		spin_box.value = value
		
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	print(bus_name, ":",str(value))
	if not bus_name.is_empty():
		GameData.set_name_volume(bus_name, value)
	
	pass
