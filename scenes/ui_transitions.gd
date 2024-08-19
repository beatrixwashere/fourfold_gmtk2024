# --- ui_transitions.gd ----
# handles ingame transitions
# --------------------------
extends CanvasLayer
func start_transition(tname: String, floornum: int = 0) -> void:
	# tween in transition screen
	$newfloor/label.text = "[center]floor " + str(floornum) + "[/center]"
	get_node(tname).visible = true
	get_node(tname).position.y += 32
	get_node(tname).modulate = Color(1,1,1,0)
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
	.tween_property(get_node(tname), "position", get_node(tname).position - Vector2(0,32), 0.5)
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
	.tween_property(get_node(tname), "modulate", Color(1,1,1,1), 0.5)
	await get_tree().create_timer(0.5).timeout
	# play animation
	$animation.play(tname)
	await $animation.animation_finished
	# tween in transition screen
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
	.tween_property(get_node(tname), "position", get_node(tname).position + Vector2(0,32), 0.5)
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
	.tween_property(get_node(tname), "modulate", Color(1,1,1,0), 0.5)
	await get_tree().create_timer(0.5).timeout
	get_node(tname).visible = false
	get_node(tname).position.y -= 32
