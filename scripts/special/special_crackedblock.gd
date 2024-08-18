# -- special_crackedblock.gd --
# handles breakable blocks
# -----------------------------
extends Area2D
# signals
func _body_entered(body: Node2D) -> void:
	if body.name == "player" && body.dash_state > 0:
		$sfx.play()
		$collision.call_deferred("set_disabled", true)
		await get_tree().create_timer(0.25).timeout
		$body/collision.disabled = true
		var tween: Tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1,1,1,0), 0.5)
		await tween.finished
		queue_free()
