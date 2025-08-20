# Multiplayer

# Information:
  Keep it simple as correct logics as project game is on going build.

  Note that doing some testing how set authority on node as it is tricky. Need some trial and error to know how it works.

# Design:
  There are couple things need to be sure and sync for peer to peer but there is serer and client.

  There are couple prefix name which is request and remote for easy naming for handling the server and client syncs.

```
func request_spawn():
	if multiplayer.is_server():
		spawn.rpc()
	else:
		remote_spawn.rpc_id(1)
	pass
@rpc("any_peer","call_remote")
func remote_spawn():
	spawn.rpc()
	pass
@rpc("authority","call_local")
func spawn():
	pass
```
  This simple spawn. It check if server the spawn will do local to server and clients. If client then request from server to spawn object. To prevent client spam spawm if there without conditions.

  This will all handle on server side and not cilent spamming in case of exploit on client side to spam.

```
func request_spawn():
	if multiplayer.is_server():
		spawn.rpc()
	else:
		remote_spawn.rpc_id(1)
	pass
```
  Server and client check.
```
@rpc("any_peer","call_remote")
func remote_spawn():
	spawn.rpc()
	pass
```
  This is from server and incoming remote client request spawn since remote_spawn.rpc_id(1). 1 = server peer id.
```
@rpc("authority","call_local")
func spawn():
	pass
```
	This will board cast to server and clients.
# Notes:
