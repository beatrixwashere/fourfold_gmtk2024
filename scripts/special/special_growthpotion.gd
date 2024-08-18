# -- special_growthpotion.gd --
# handles growth potion effect
# -----------------------------
extends Area2D
func _body_entered(body: Node2D) -> void:
	if body.name == "player":
		$sfx.play()
		$collision.call_deferred("set_disabled", true)
		$body/collision.call_deferred("set_disabled", true)
		get_node("../key/body/collision").call_deferred("set_disabled", true)
		create_tween().tween_property(body, "scale", Vector2(4,4), 0.5)
		create_tween().tween_property(self, "modulate", Color(1,1,1,0), 0.5)
		create_tween().tween_property(body.get_node("background"), "scale", Vector2(2,2), 0.5)
		create_tween().tween_property(body.get_node("background/layer"), "motion_scale", Vector2(0.5,0.5), 0.5)
		create_tween().tween_property(get_tree().current_scene.get_node("camera"), "zoom", Vector2(0.5,0.5), 0.5)
		await get_tree().create_timer(1.0).timeout
		queue_free()
