class_name PlayerState extends State

const IDLE = "Idle" # node name
const RUNNING = "Running"
const WALKING = "Walking" 
const JUMPING = "Jumping"
const FALLING = "Falling"
const DEATH = "Death"
const CROUCHING = "Crouching"
const PRONE = "Prone"
const FLYING = "Flying"
const GHOST = "Ghost"
const SLIDING = "Sliding"
const LADDER = "Ladder"
const WALLRUNNING = "WallRunning"
 
var toggle_croucn:bool = true
var toggle_prone:bool = true
var toggle_sprint:bool = true

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
