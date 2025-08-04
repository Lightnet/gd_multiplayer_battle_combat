```
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_3d: Area3D = $Area3D # Reference to your Area3D node
var is_collision_enabled: bool = false

func attack() -> void:
    if not animation_player.is_playing():
        print("play attack animation")
        is_collision_enabled = true # Enable collision at animation start
        animation_player.play("attack")
        # Connect animation finished signal if not already connected
        if not animation_player.is_connected("animation_finished", _on_animation_finished):
            animation_player.connect("animation_finished", _on_animation_finished)

func _on_area_3d_body_entered(body: Node3D) -> void:
    if is_collision_enabled:
        print("melee body:", body)
        # Add your collision handling logic here
        # For example, apply damage to the body if it's an enemy
        if body.has_method("take_damage"):
            body.take_damage(10) # Example damage value

func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "attack":
        is_collision_enabled = false # Disable collision when animation ends
        print("attack animation finished, collision reset")
```