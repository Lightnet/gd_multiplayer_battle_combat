extends Node

#================================================
# Player Data Handle
#================================================

var player_data:PlayerData # current player
var save_player_data:PlayerData # save state last battle

func set_player_data(_player_data:PlayerData):
	player_data = _player_data
	pass
	
#================================================
# SCENE Handle
#================================================

# battle scene
var next_scene:String = ""

# player scene when go to battle to save.
var open_world_scene_path:String = ""
var open_world_position:Vector3
var is_defeated:bool = false #make sure the player is either win or lose for handle defeat result

#================================================
# RANDOM GEN STR CHARACTERS 16
#================================================

# change the scene handler
var game_controller:GameController

#================================================
# RANDOM GEN STR CHARACTERS 16
#================================================
# Length of the random ID
var id_length: int = 16

# Character set for generating the random ID (alphanumeric)
const CHARACTERS: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

# Generates a random ID string
func generate_random_id() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize() # Ensure different random seed each run
	var result = ""
	for i in range(id_length):
		var index = rng.randi_range(0, CHARACTERS.length() - 1)
		result += CHARACTERS[index]
	return result

#================================================
# MOB
#================================================
var current_mob_id:String # current creature attack player or event ecounter
#var mobs:Array[MapCreatureData] # store current mob defeated

## add mob to map tablet that player encounter
func add_mob(_map_name,_id:String):
	current_mob_id = _id
	#var mob_data = MapCreatureData.new()
	#mob_data.name = _map_name
	#mob_data.id = _id
	#mobs.append(mob_data)
	pass

#TODO need rework and for quest count creature???
func defeat_mob():
	#for mob in mobs:
		#if mob.id == current_mob_id:
			#mob.is_defeat = true
	pass
