extends PanelContainer

@onready var label: Label = $MarginContainer/HBoxContainer/Label

#func _ready() -> void:
	
	#pass

#func _process(delta: float) -> void:
	
	#pass

func set_player_name(_name:String):
	label.text = _name
	#pass
