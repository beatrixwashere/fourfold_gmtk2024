# -- game_timer.gd --
# handles time limit
# -------------------
extends CanvasLayer
var timeleft: int = 30
func _ready() -> void:
	iterate_timer()
func iterate_timer() -> void:
	await get_tree().create_timer(1.0).timeout
	timeleft -= 1
	var labeltext: String = ""
	if timeleft <= 10:
		labeltext += "[shake rate=20.0 level=5 connected=1][color=red]"
	labeltext += "[center]" + str(timeleft)
	$f/label.text = labeltext
	$f.scale = Vector2(1.5,1.5)
	create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT). \
	tween_property($f, "scale", Vector2(1,1), 0.5)
	if timeleft > 0:
		iterate_timer()
	else:
		sequence.end_game()
		get_tree().current_scene.get_node("player").can_update = false
		get_tree().current_scene.get_node("player/door_enter").fade_out()
