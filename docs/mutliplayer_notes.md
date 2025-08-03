

# Multiplayer api:

- Custom Binary Serialization
- JSON Strings
- Dictionaries
- 

# rpc sent types:

## Serialize to a Dictionary or Array:
```
	# Sending side
	var my_resource_data = {
		"property1": my_resource.property1,
		"property2": my_resource.property2
	}
	rpc("receive_resource_data", my_resource_data)

	# Receiving side
	remote func receive_resource_data(data):
		var new_resource = MyResourceType.new()
		new_resource.property1 = data.property1
		new_resource.property2 = data.property2
		# Use the new_resource
```
## Serialize to a Byte Array:
```
	# Sending side
	var resource_bytes = var_to_bytes(my_resource)
	rpc("receive_resource_bytes", resource_bytes)

	# Receiving side
	remote func receive_resource_bytes(bytes):
		var received_resource = bytes_to_var(bytes) as MyResourceType
		# Use the received_resource
```

## Resource methods:
```
# On the sending peer (e.g., client)
@rpc("authority", "reliable")
func _send_item_data_to_server(item_name: String, item_value: int):
	# This function would be called on the server
	pass

func _on_item_collected(item_resource: MyItemResource):
	_send_item_data_to_server.rpc_id(1, item_resource.name, item_resource.value) # Assuming server has ID 1

# On the receiving peer (e.g., server)
@rpc("authority", "reliable")
func _send_item_data_to_server(item_name: String, item_value: int):
	print("Received item data: ", item_name, " with value ", item_value)
	# Update server-side game state based on received data
```

# Notes:
