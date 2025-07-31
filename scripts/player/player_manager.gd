extends Node

var player
var state_menu:String = "none"
#var res_player_path = "user://player_res.tres"

func use_slot_data(slot_data:SlotData) -> void:
	slot_data.item_data.use(player)
	#pass

func get_global_position() -> Vector3:
	return player.global_position

func disable_menu():
	state_menu = "none"

func enable_menu():
	state_menu = "menu"

func is_enable_controller() -> bool:
	
	if state_menu == "menu":
		return false
		
	return true
	
#
