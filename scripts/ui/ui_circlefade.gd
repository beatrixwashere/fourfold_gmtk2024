# ---------- ui_circlefade.gd ----------
# handles the scene transition animation
# --------------------------------------
extends ColorRect
var canhide: bool = true
func _ready() -> void:
	visible = true
	get_node("../background").visible = true
	material.set_shader_parameter("size", 0.0)
	await get_tree().create_timer(0.5).timeout
	fade_in()
func fade_in() -> void:
	var tweenshader: Callable = func _tweenshader(value: float) -> void:
		material.set_shader_parameter("size", value)
	var tween: Tween = create_tween()
	tween.tween_method(tweenshader, 0.0, 300.0, 1.0)
	await tween.finished
	await get_tree().create_timer(0.2).timeout
	if canhide:
		visible = false
func fade_out() -> void:
	visible = true
	canhide = false
	var tweenshader: Callable = func _tweenshader(value: float) -> void:
		material.set_shader_parameter("size", value)
	var tween: Tween = create_tween()
	tween.tween_method(tweenshader, 300.0, 0.0, 1.0)
	await tween.finished
	await get_tree().create_timer(0.2).timeout
	canhide = true
