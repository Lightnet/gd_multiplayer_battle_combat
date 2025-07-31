extends CenterContainer

@export var DOT_RADIUS:float = 1.0
@export var DOT_COLOR:Color = Color.WHITE

#func _ready() -> void:
	#pass

#func _process(delta: float) -> void:
	#pass

func _draw():
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOR)
