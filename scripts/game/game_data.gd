extends Node

#signal update_player_info(_player_data:PlayerData)

const CONFIG_PATH = "user://gameconfig.tres"
var player_data_slots_path = "user://player_slots/"
var game_config:GameConfig

func _ready() -> void:
	# Load or create config
	var config = get_config()
	if config:
		game_config = config
	load_audio_volume()
	check_player_inputs_exist()
	load_player_input_keybinds()
	#pass

#check if dir exist else create dir
func check_name_folder(_name):
	var dir = DirAccess.open("user://")
	if dir.dir_exists(_name):
		#print("researchs exist")
		pass
	else:
		dir.make_dir(_name)
		#print("researchs create")
	#pass

# Create and save default config if it doesn't exist
static func get_config() -> GameConfig:
	var config: GameConfig
	# Check if config file exists
	if ResourceLoader.exists(CONFIG_PATH):
		config = ResourceLoader.load(CONFIG_PATH) as GameConfig
	else:
		# Create default config
		config = GameConfig.new()
		# Save default config
		ResourceSaver.save(config, CONFIG_PATH)
	return config

# Save config to file
static func save_config(config: GameConfig) -> void:
	var error = ResourceSaver.save(config, CONFIG_PATH)
	if error != OK:
		push_error("Failed to save config: %s" % error_string(error))
		
func set_name_volume(_name:String, volume:float ):
	if game_config:
		if _name == "Master":
			game_config.master_volume = volume
			save_config(game_config)
		if _name == "sfx":
			game_config.sfx_volume = volume
			save_config(game_config)
		if _name == "music":
			game_config.music_volume = volume
			save_config(game_config)
		#if _name == "voice":
			#game_config.voice_volume = volume
			#save_config(game_config)
		if _name == "menu":
			game_config.menu_volume = volume
			save_config(game_config)
	pass
func get_name_volume(_name:String):
	if game_config:
		if _name == "Master":
			return game_config.master_volume
		if _name == "sfx":
			return game_config.sfx_volume
		if _name == "music":
			return game_config.music_volume
		#if _name == "voice":
			#return game_config.voice_volume
		if _name == "menu":
			return game_config.menu_volume
	else:
		return 0.0
func load_audio_volume():
	if game_config:
		
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(game_config.master_volume)
		)
		
		bus_index = AudioServer.get_bus_index("sfx")
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(game_config.sfx_volume)
		)
		
		bus_index = AudioServer.get_bus_index("music")
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(game_config.music_volume)
		)
		
		#bus_index = AudioServer.get_bus_index("voice")
		#AudioServer.set_bus_volume_db(
			#bus_index,
			#linear_to_db(game_config.voice_volume)
		#)
		
		bus_index = AudioServer.get_bus_index("menu")
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(game_config.menu_volume)
		)
		pass
	pass
	
#================================================
# INPUT KEYBINDS
#================================================
func check_player_inputs_exist() -> void:
	var config = ConfigFile.new()
	var config_path = "user://keybinds.cfg"
	
	# Check if the config file exists
	if config.load(config_path) != OK:
		# File doesn't exist, create it with default keybinds
		var default_keybinds = {
			"forward": KEY_W,
			"backward": KEY_S,
			"left": KEY_A,
			"right": KEY_D,
			"jump": KEY_SPACE,
			"crouch": KEY_CTRL
			# Add more default actions as needed
		}
		
		# Set default keybinds in the config
		for action in default_keybinds.keys():
			config.set_value("keybinds", action, default_keybinds[action])
		
		# Save the config file
		var error = config.save(config_path)
		if error == OK:
			print("Created new keybinds config file at: ", config_path)
		else:
			print("Failed to create keybinds config file: ", error)
			
func load_player_input_keybinds() -> void:
	var config = ConfigFile.new()
	# Load the configuration file
	if config.load("user://keybinds.cfg") == OK:
		# Check if the "keybinds" section exists
		if config.has_section("keybinds"):
			# Iterate through all keys in the "keybinds" section
			for action in config.get_section_keys("keybinds"):
				var keycode = config.get_value("keybinds", action)
				if keycode is int:
					# Clear existing events for the action
					InputMap.action_erase_events(action)
					# Create a new InputEventKey
					var event = InputEventKey.new()
					event.physical_keycode = keycode
					# Add the event to the InputMap
					InputMap.action_add_event(action, event)
