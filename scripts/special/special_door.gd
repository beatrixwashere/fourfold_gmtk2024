# ---- special_door.gd ----
# handles doors in the menu
# -------------------------
extends Area2D
var active: bool = false
var player: CharacterBody2D
var camera: Camera2D
var markers: Node2D
# sets up variables
func _ready() -> void:
	player = get_tree().current_scene.get_node("player")
	camera = get_tree().current_scene.get_node("camera")
	if get_tree().current_scene.has_node("markers"):
		markers = get_tree().current_scene.get_node("markers")
	pass
# option selection
func _input(event: InputEvent) -> void:
	if active && event is InputEventKey && event.keycode == KEY_SPACE:
		active = false
		match name:
			"floor":
				if get_tree().current_scene.has_node("timer"):
					get_tree().current_scene.get_node("timer/countdown").stop()
					get_tree().current_scene.get_node("timer").queue_free()
				player.can_update = false
				$sfx.play()
				await player.get_node("door_enter").fade_out()
				match get_parent().name:
					"speedboost": sequence.upgrades[0] += 1
					"jumpboost": sequence.upgrades[1] += 1
					"dashboost": sequence.upgrades[2] += 1
				sequence.new_floor()
			"next":
				if get_tree().current_scene.has_node("timer"):
					get_tree().current_scene.get_node("timer/countdown").stop()
					get_tree().current_scene.get_node("timer").queue_free()
				player.can_update = false
				$sfx.play()
				await player.get_node("door_enter").fade_out()
				sequence.next_room()
			"play":
				player.can_update = false
				$sfx.play()
				await player.get_node("door_enter").fade_out()
				transitions.start_transition("tutorial")
				await get_tree().create_timer(2.0).timeout
				transitions.get_node("loadfix").visible = true
				get_tree().change_scene_to_file("res://scenes/rooms/tutorial.tscn")
				transitions.get_node("loadfix").visible = false
				music.change_smooth(0, 1)
			"settings":
				door_helper("settings")
			"credits":
				door_helper("credits")
			"extras":
				door_helper("extras")
			"return":
				door_helper("main")
			"exit":
				player.can_update = false
				$sfx.play()
				await player.get_node("door_enter").fade_out()
				get_tree().quit()
				# if quit doesn't get called for whatever reason
				await get_tree().create_timer(1.0).timeout
				player.get_node("door_enter").fade_in()
				player.can_update = true
# helper function for going through menu doors
func door_helper(room: String) -> void:
	player.can_update = false
	$sfx.play()
	await player.get_node("door_enter").fade_out()
	player.position = markers.get_node(room + "_playerpos").position
	camera.position = markers.get_node(room + "_camerapos").position
	player.get_node("door_enter").fade_in()
	player.can_update = true
# signals
func _body_entered(body: Node2D) -> void:
	if body.name == "player":
		active = true
func _body_exited(body: Node2D) -> void:
	if body.name == "player":
		active = false
