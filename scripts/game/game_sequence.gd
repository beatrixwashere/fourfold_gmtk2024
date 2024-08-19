# --- game_sequence.gd ----
# handles the gameplay loop
# -------------------------
extends Node
var levelqueue: Array[int]
var leveldiff: String
var floornum: int = 0
var roomclears: int = 0
func new_floor() -> void:
	if get_tree().current_scene.has_node("timer"):
		get_tree().current_scene.get_node("timer").queue_free()
	if floornum == 0: music.play_ingame()
	floornum += 1
	levelqueue = [0,1,2,3,4]
	levelqueue.shuffle()
	leveldiff = "beginner"
	await transitions.start_transition("newfloor", floornum)
	var nextlvl: int = levelqueue.pop_back()
	get_tree().change_scene_to_file("res://scenes/rooms/" + leveldiff + "_" + str(nextlvl) + ".tscn")
func next_room() -> void:
	if get_tree().current_scene.has_node("timer"):
		get_tree().current_scene.get_node("timer").queue_free()
	roomclears += 1
	if levelqueue.size() > 0:
		await transitions.start_transition("newroom", floornum)
		var nextlvl: int = levelqueue.pop_back()
		get_tree().change_scene_to_file("res://scenes/rooms/" + leveldiff + "_" + str(nextlvl) + ".tscn")
	else:
		music.stop_ingame()
		await transitions.start_transition("newroom", floornum)
		get_tree().change_scene_to_file("res://scenes/rooms/shop.tscn")
func end_game() -> void:
	music.stop_ingame()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
