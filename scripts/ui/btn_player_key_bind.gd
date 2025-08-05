extends Button

@export var action_name: String = "forward" ## project input name
@export var action_label: String = "Forward" ## Optional: for display purposes
@export var cancel_key: Key = KEY_ESCAPE ## Key to cancel keybinding

var is_keybind: bool = false

func _ready() -> void:
	set_process_unhandled_input(false)
	load_keybind() # Load keybinding from config
	update_button_text()
	# Only connect pressed signal, as toggle_mode is assumed enabled
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	is_keybind = !is_keybind
	if is_keybind:
		text = "Press a key..."
		set_process_unhandled_input(true)
		
		# Disable other hotkey buttons
		for button in get_tree().get_nodes_in_group("hotkey_button"):
			if button != self:
				button.button_pressed = false
				button.is_keybind = false
				button.set_process_unhandled_input(false)
	else:
		set_process_unhandled_input(false)
		update_button_text()

func update_button_text() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() > 0:
		var event = action_events[0]
		if event is InputEventKey:
			var keycode = OS.get_keycode_string(event.physical_keycode)
			text = keycode
	else:
		text = action_label if action_label else action_name

func _unhandled_key_input(event: InputEvent) -> void:
	if not is_keybind:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == cancel_key:
			# Cancel keybinding
			is_keybind = false
			set_process_unhandled_input(false)
			update_button_text()
		else:
			# Rebind with the pressed key
			rebind_action_key(event)
			is_keybind = false
			set_process_unhandled_input(false)
			update_button_text()
		get_viewport().set_input_as_handled()

func rebind_action_key(event: InputEvent) -> void:
	# Clear existing key bindings for this action
	InputMap.action_erase_events(action_name)
	
	# Add new key binding
	InputMap.action_add_event(action_name, event)
	
	# Save the new binding
	save_keybind()

func save_keybind() -> void:
	var config = ConfigFile.new()
	config.load("user://keybinds.cfg")
	config.set_value("keybinds", action_name, InputMap.action_get_events(action_name)[0].physical_keycode)
	config.save("user://keybinds.cfg")

func load_keybind() -> void:
	var config = ConfigFile.new()
	if config.load("user://keybinds.cfg") == OK:
		if config.has_section_key("keybinds", action_name):
			var keycode = config.get_value("keybinds", action_name)
			if keycode is int:
				# Clear existing events for the action
				InputMap.action_erase_events(action_name)
				# Create a new InputEventKey
				var event = InputEventKey.new()
				event.physical_keycode = keycode
				# Add the event to the InputMap
				InputMap.action_add_event(action_name, event)
				# Update the button text to reflect the loaded key
				update_button_text()

func _enter_tree() -> void:
	add_to_group("hotkey_button")
	Console.add_command("showinputkeys", cmd_inputkeys)
	
func _exit_tree() -> void:
	Console.remove_command("showinputkeys")
	pass
	
func cmd_inputkeys() ->void:
	# Get all actions defined in the InputMap
	var actions = InputMap.get_actions()
	
	# Iterate through each action
	for action in actions:
		var events = InputMap.action_get_events(action)
		var action_info = str(action) + ": "
		
		# Check if the action has any events
		if events.size() > 0:
			var event_strings = []
			for event in events:
				if event is InputEventKey:
					var keycode = OS.get_keycode_string(event.physical_keycode)
					event_strings.append(keycode)
			if event_strings.size() > 0:
				action_info += ", ".join(event_strings)
			else:
				action_info += "No key bindings"
		else:
			action_info += "No key bindings"
		
		# Print the action and its bindings
		print(action_info)
	pass
