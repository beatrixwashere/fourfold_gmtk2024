# -- special_key.gd --
# handles the end key
# --------------------
extends Area2D
func _body_entered(body: Node2D) -> void:
	if body.name == "player":
		$sfx.play()
		$collision.call_deferred("set_disabled", true)
		get_node("../gate/collision").call_deferred("set_disabled", true)
		create_tween().tween_property(self, "modulate", Color(1,1,1,0), 0.5)
		create_tween().tween_property(get_node("../gate"), "modulate", Color(1,1,1,0), 0.5)
		await get_tree().create_timer(0.5).timeout
		queue_free()
