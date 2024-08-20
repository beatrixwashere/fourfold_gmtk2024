# --- game_sequence.gd ----
# handles the gameplay loop
# -------------------------
extends Node
var levelqueue: Array[int]
var leveldiff: String
var floornum: int = 0
var roomclears: int = 0
var upgrades: Array[int] = [0,0,0]
func new_floor() -> void:
	music.play_ingame()
	floornum += 1
	levelqueue = [0,1,2,3,4]
	levelqueue.shuffle()
	leveldiff = "beginner"
	await transitions.start_transition("newfloor", floornum)
	var nextlvl: int = levelqueue.pop_back()
	transitions.get_node("loadfix").visible = true
	get_tree().change_scene_to_file("res://scenes/rooms/" + leveldiff + "_" + str(nextlvl) + ".tscn")
	transitions.get_node("loadfix").visible = false
func next_room() -> void:
	roomclears += 1
	if levelqueue.size() > 0:
		await transitions.start_transition("newroom", floornum)
		var nextlvl: int = levelqueue.pop_back()
		transitions.get_node("loadfix").visible = true
		get_tree().change_scene_to_file("res://scenes/rooms/" + leveldiff + "_" + str(nextlvl) + ".tscn")
		transitions.get_node("loadfix").visible = false
	else:
		music.stop_ingame()
		await transitions.start_transition("newroom", floornum)
		transitions.get_node("loadfix").visible = true
		get_tree().change_scene_to_file("res://scenes/rooms/shop.tscn")
		transitions.get_node("loadfix").visible = false
func end_game() -> void:
	music.stop_ingame()
	await get_tree().create_timer(2.0).timeout
	transitions.get_node("loadfix").visible = true
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	transitions.get_node("loadfix").visible = false
