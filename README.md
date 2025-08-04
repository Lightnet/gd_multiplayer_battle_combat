# gd multiplayer battle combat

# Information:
 Work in progress. 
 
 This sample project for multiplayer. To know how GodotEngine Multiplayer Peer works. There no auth checks yet.

 To create some basic features for player controller to make first person shooter and melee. As well how handle entity projectiles and hit collisions. It will be expand later for combat system test. 

# Features and work in progress:
 - [ ] network
 	- [x] host
 	- [x] join 
	- [ ] leave game to clean up player entity
	- [ ] disconnect clean up
 - [ ] glboal
 	- [x] change scene
	- [x] name generator
	- [ ] 
 - [ ] scene
 	- [x] simple game logic spawn
 	- [x] set player position
 	- [x] inputs
	- [ ] quit clean up
 - [ ] entity
 	- [x] health check and damage
 	- [x] damage
 	- [x] projectiles
	- [x] dummy melee (simple test)
	- [x] spawn dummy cube (not collision)
	- [x] spawn dummy projectile cube (move in -z direction)
 - [ ] player
	- [x] movement
	- [x] weapon bullet 0
	- [x] weapon bullet 1
	- [x] jump
	- [x] camera
	- [x] shoot
		- [x] projectile collision test
		- [ ] layer and mask testing
	- [x] melee test with animation simple
 - [ ] ui
	- [x] main menu
	- [x] multiplayer
	- [x] lobby
	- [ ] game menu
	- [ ] settings
 - [ ] config
	- [ ] save
	- [ ] load
 - [ ] dev console 

# scenes:
- scenes/game_controller_player_test.tscn
	- single player test
- scenes/game_controller_host_join.tscn
	- multiplayer test

# dev console:
 This section is for dev console using the backqute for half life console commands. It use an add on plugin from assets.

 This is work in progress to make sure the network server and client are sync.

```
players # List peer id and name
ping # get  multiplayer.get_unique_id(), multiplayer.is_server()
```

# Network:
  RPCs (Remote Procedure Calls)

  Just prototyping how to handle network. Need to have sync and spawn item correctly.
  
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
	For reason for await is need to wait for node tree to be added and update the data to scene to other peers else error.

	As well assign the set_multiplayer_authority on the node to handle identity on the network for who in control of the instance or create to node object.

  Note that class resources does not work as become object type in rpc. It can only send parameters not object data.
```
```
# List:
- Dictionary 
- Array
- 

## notes:
 - Allowing direct transmission of arbitrary objects could pose security risks, as it might enable remote code injection or other vulnerabilities if not handled carefully.

# Collision:
	
## Rigbody3D:
  Need to config the Solver to able collision event for _on_body_shape_entered.
```
contact_monitor = true
max_contacts_reported = 1
```

# game logics:
	
```
-Host / Join
-Load Scene
-Scene Level
	-call server for this client or server to add counter
	-start_game

-Game

```


# Notes:
- network error sync on
	- projectile spawn out of sync
	- spawn player out out of sync
	- 

# Design notes:
  - Host and Join are working
  - sync issues or incorrect coding.
  -	Battle for being number One.
  -	Multiplayer combat for jobs or hero?
  -	One goal be solo surival of the match or 1vs1 battle.
