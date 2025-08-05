extends OptionButton

const RESOLUTION_DICTIONARY:Dictionary = {
	"1152 x 648":Vector2i(1152,648),
	"1280 x 720":Vector2i(1280,720),
	"1920 x 1080":Vector2i(1920,1080)
}

func _ready() -> void:
	item_selected.connect(on_resolution_select)
	add_resolution_items()
	pass
	
func add_resolution_items()->void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		add_item(resolution_size_text)
	pass
	
func on_resolution_select(index:int)->void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	pass
