# Network:
  RPCs (Remote Procedure Calls)

  Just prototyping how to handle network. Need to have sync and spawn item correctly.

 Work in progress.

# Logics:
  When character is assign the set_multiplayer_authority which will effect how to handle the server and client.

  For the reason for authority will refernce either server or client for who own the node.set_multiplayer_authority(peer_id) that is to prevent other client override controllers. That I am thinking. But it can be abuse in some degree.

# layout:
  
  Note that need to set up and assign set_multiplayer_authority(player id) when handle player who own to spawn item props.
```
@rpc("call_local")
func shoot(shooter_pid):
	var bullet = BULLET.instantiate()
	bullet.set_multiplayer_authority(shooter_pid)
	get_parent().add_child(bullet)
	# delay 
	await get_tree().create_timer(0.01).timeout #wait for sync
	bullet.transform = $GunCOntainer/GunSprite/Muzzle.global_transform
```
  For reason for await is need to wait for node tree to be added and update the data to scene to other peers else error. As well assign the set_multiplayer_authority on the node to handle identity on the network for who in control of the instance or create to node object.

  Note that class resources does not work as become object type in rpc. It can only send parameters not object data. In simple words very basic variable like string, int, float and array types. Will use round about ways.
```
# player , character3d
func _on_receive_hit(hit_info_data:HitInfoData)->void:
	print("player name id:", name)
	_on_receive_hit_params.rpc_id(get_multiplayer_authority(), "Physical", 10)
	pass

@rpc("any_peer","call_local") #
func _on_receive_hit_params(_type:String,_amount:float)->void:
	if _type == "Physical":
		stats_data.health -= _amount
		print("HEALTH: ", stats_data.health)
	pass
```
  As long the objects are sync to able to call_local to update variable.
