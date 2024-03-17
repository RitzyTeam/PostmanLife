extends AudioStreamPlayer3D

var isPlaying: bool = false

func use_singing():
	if isPlaying:
		play()

func _sing_allowed():
	isPlaying = true
	play()

func _sing_disallowed():
	isPlaying = false
	stop()

func _on_finished():
	use_singing()

func _on_timer_timeout():
	if SIN_WORLD_DATA.WORLD_DATA['tod'] > 120 and SIN_WORLD_DATA.WORLD_DATA['tod'] < 1360:
		_sing_disallowed()
	if SIN_WORLD_DATA.WORLD_DATA['tod'] > 1360:
		_sing_allowed()
