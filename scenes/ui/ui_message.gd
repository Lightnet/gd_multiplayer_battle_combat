extends PanelContainer

@onready var label_user: Label = $MarginContainer/HBoxContainer/LabelUser
@onready var label_message: Label = $MarginContainer/HBoxContainer/LabelMessage

func set_user_message(_user,_msg):
	label_user.text = _user
	label_message.text = _msg
	#pass
