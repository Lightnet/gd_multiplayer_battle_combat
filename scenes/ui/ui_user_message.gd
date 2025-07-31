extends HBoxContainer

@onready var label_user: Label = $Label_User
@onready var label_message: Label = $Label_Message

func set_name_message(_name:String, _message:String)->void:
	label_user.text = _name
	label_message.text = _message
	#pass
