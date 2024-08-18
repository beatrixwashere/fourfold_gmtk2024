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
