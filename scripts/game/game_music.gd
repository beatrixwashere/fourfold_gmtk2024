# --------- game_music.gd ----------
# controls music playback and volume
# ----------------------------------
extends AudioStreamPlayer
func _ready() -> void:
	volume_db = -60
	var tween:Tween = create_tween()
	tween.tween_property(self, "volume_db", 0, 1.5)
func change_smooth(from: int, to: int) -> void:
	var set_volume: Callable = func _set_volume(vol: float, idx: int) -> void:
		stream.set_sync_stream_volume(idx, vol)
	create_tween().tween_method(set_volume.bind(from), 0, -6, 1.0)
	create_tween().tween_method(set_volume.bind(to), -60, -6, 1.0)
	create_tween().tween_method(set_volume.bind(from), -6, -60, 1.0)
	create_tween().tween_method(set_volume.bind(to), -6, 0, 1.0)
func play_ingame() -> void:
	await create_tween().tween_property(self, "volume_db", -60, 2.0).finished
	$ingame.play()
func stop_ingame() -> void:
	await create_tween().tween_property($ingame, "volume_db", -60, 2.0).finished
	$ingame.stop()
	stream.set_sync_stream_volume(0, 0)
	stream.set_sync_stream_volume(1, -60)
	create_tween().tween_property(self, "volume_db", 0, 1.0)
