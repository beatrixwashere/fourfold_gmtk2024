# -------- ui_settings.gd ---------
# adjusts and saves volume settings
# ---------------------------------
extends Control
# load config files
func _ready() -> void:
	var file: FileAccess = FileAccess.open("user://volume.ffconfig", FileAccess.READ)
	if file && false: # disabled bc it doesn't work
		await get_tree().create_timer(1.0).timeout
		var music_volume: int = file.get_8()
		print(music_volume)
		if music_volume > 0: AudioServer.set_bus_volume_db(1, 6 * log(music_volume / 10.0) / log(2))
		AudioServer.set_bus_mute(1, music_volume == 0)
		$music/slider.value = music_volume
		var sfx_volume: int = file.get_8()
		print(sfx_volume)
		if sfx_volume > 0: AudioServer.set_bus_volume_db(1, 6 * log(sfx_volume / 10.0) / log(2))
		AudioServer.set_bus_mute(1, sfx_volume == 0)
		$sfx/slider.value = sfx_volume
	if sequence.floornum > 0:
		get_tree().current_scene.get_node("player").position = \
		get_tree().current_scene.get_node("markers/gameover_playerpos").position
		get_tree().current_scene.get_node("camera").position = \
		get_tree().current_scene.get_node("markers/gameover_camerapos").position
		get_tree().current_scene.get_node("labels/gameover/floor").text = \
		"[wave amp=30.0 freq=3.0 connected=1][center]final floor: " + str(sequence.floornum) + "[/center][/wave]"
		get_tree().current_scene.get_node("labels/gameover/rooms").text = \
		"[wave amp=30.0 freq=3.0 connected=1][center]rooms cleared: " + str(sequence.roomclears) + "[/center][/wave]"
		sequence.floornum = 0
		sequence.roomclears = 0
		sequence.upgrades = [0,0,0]
# change bus volume from slider and save to file
func change_bus_volume(value: float, idx: int) -> void:
	if value > 0: AudioServer.set_bus_volume_db(idx, 6 * log(value / 10.0) / log(2))
	AudioServer.set_bus_mute(idx, value == 0)
	var file: FileAccess = FileAccess.open("user://volume.ffconfig", FileAccess.WRITE)
	file.store_8(int($music/slider.value))
	file.store_8(int($sfx/slider.value))
