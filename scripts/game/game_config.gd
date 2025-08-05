class_name GameConfig extends Resource

@export var language:String = "english"

@export var master_volume:float = 1.0
@export var sfx_volume:float = 1.0
@export var music_volume:float = 1.0
@export var voice_volume:float = 1.0
@export var menu_volume:float = 1.0

@export var window_mode:String = "window"
@export var window_flag_borderless:bool = false

const MOVE_FORWARD:String = "forward"
const MOVE_BACKWARD:String = "backward"
const MOVE_RIGHT:String = "right"
const MOVE_LEFT:String = "left"
const JUMP:String = "jump"

@export var DEFAULT_FORWARD_KEY = InputEventKey.new()
@export var DEFAULT_BACKWARD_KEY = InputEventKey.new()
@export var DEFAULT_RIGHT_KEY = InputEventKey.new()
@export var DEFAULT_LEFT_KEY = InputEventKey.new()
@export var DEFAULT_JUMP_KEY = InputEventKey.new()

var move_forward_key = InputEventKey.new()
var move_backward_key = InputEventKey.new()
var move_left_key = InputEventKey.new()
var move_right_key = InputEventKey.new()
