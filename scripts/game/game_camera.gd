# --- game_camera.gd ----
# handles camera movement
# -----------------------
extends Camera2D
@onready var player: CharacterBody2D = get_node("../player")
func _physics_process(_delta: float) -> void:
	position = player.position
