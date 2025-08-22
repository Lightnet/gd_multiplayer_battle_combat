# gd multiplayer battle combat

# License: MIT

# Godot Engine: 4.4.1

# Information:
  Work in progress.

  The sample build for multiplayer has some simple lobdy, chat, player shoot, death on random spawn reset to health. Has basic player controller to make first person shooter and melee attack test. As well how handle entity projectiles and hit collisions.
 
  To know how Godot Engine Multiplayer API Peers works. It will be expand later for combat system test. 

# Features and work in progress:
 - [ ] network
 	- [x] host
 	- [x] join
		- [x] check for fail connect to server which return to host and join.
	- [ ] leave game to clean up player entity
	- [ ] disconnect clean up
 - [ ] global
 	- [x] change scene
	- [x] name generator
	- [ ] 
 - [ ] scene
 	- [x] simple game logic spawn
 	- [x] set player position
	- [x] random spawn location
 	- [x] inputs
	- [ ] quit clean up
 - [ ] entity
 	- [x] health check and damage
 	- [x] damage
 	- [x] projectiles
	- [x] dummy melee (simple test)
	- [x] spawn dummy cube (not collision)
	- [x] spawn dummy projectile cube (move in forward -z direction)
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
		- [x] volume
		- [x] window mode
		- [x] resolution
		- [x] game config
		- [x] game input
 - [ ] config
	- [ ] save
	- [ ] load
 - [ ] dev console 
 - [ ] notify
	- [ ] notify message
 - [ ] dialog
	- [ ] ban user
	- [ ] access deined
	- [ ] disconnect
	- [ ] connect
	
# Controls:
- add simple help menu f1
- W,A,S,D = movement
- Mouse Move = Camera Rotate
- Escape = toggle capture screen
- backqute = Dev Console
- F1 = Game Menu
- ...

# Scenes:
- scenes/game_controller_player_test.tscn
	- single player test
- scenes/game_controller_host_join.tscn
	- multiplayer test

# Dev Console:
 This section is for dev console using the backqute for half life console commands. It use an add on plugin from assets.

 This is work in progress to make sure the network server and client are sync.

```
players # List peer id and name
ping # get  multiplayer.get_unique_id(), multiplayer.is_server()
```

# Network mutliplayer:
  Work in progress.

# List:
- Dictionary 
- Array
- String
- int
- float
- bool

## Notes:
 - Allowing direct transmission of arbitrary objects could pose security risks, as it might enable remote code injection or other vulnerabilities if not handled carefully.
 - Animation sync need to config as different from server and client fallback or go to default pose animation to reset zero.

# Collision:
  There two type physics collision  and area detect. It depend on the job.

## Rigbody3D:
  Need to config the Solver to able collision event for _on_body_shape_entered.
```
contact_monitor = true
max_contacts_reported = 1
```

# Game Logics:
	
```
-autoload script
	- GameData
		- this handle save and load config
	- Global
		- this handle scene change for scene 2d and 3d, GUI (graphic user interface)
		- handle notify message if exist in the scene
	- GameNetwork
		- this handle network set up for server and client

-Host / Join
-Load Scene
-Scene Level
	- call server for this client or server to add counter
	- start_game
	- handle disconnect on client peer
```
# Multiplayer start and loading:
- When the start scene load path file
	- wait for scene load and client to add counter
- check while clients finish loading (need to prevent other player join in later)
- initial spawn players
- death check (not added)

# Notes:
- network error sync on
	- projectile spawn out of sync due to name set by godot api
	- spawn player out out of sync due to main server need to wait for scene to loaded first for clients to sync.
	- strange capture screen which error out the sync when out focus when capture mouse out sync 
	- 

# Design notes:
  - Host and Join are working
  - sync issues or incorrect coding.
  -	Battle for being number One.
  -	Multiplayer combat for jobs or hero?
  -	One goal be solo surival of the match or 1vs1 battle.

# Credits:
- https://kenney.nl/assets
	- https://kenney.nl/assets/input-prompts
