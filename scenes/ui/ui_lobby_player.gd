extends PanelContainer

@onready var label: Label = $MarginContainer/HBoxContainer/Label

var player_name:String = ""
var player_id:int = 0

#func _ready() -> void:
	
	#pass

#func _process(delta: float) -> void:
	
	#pass

func set_player_name(_name:String, id:int):
	player_id = id
	player_name = _name
	label.text = _name
	#pass
