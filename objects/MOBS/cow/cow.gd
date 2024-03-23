extends StaticBody3D

func _ready():
	reset_moo()

func reset_moo():
	$interval_between_moo.wait_time = randi_range(20, 50)
	$interval_between_moo.start()

func _on_interval_between_moo_timeout():
	var moo_id: int = randi_range(0, 2)
	match moo_id:
		0:
			$cow_moo_1.pitch_scale = randf_range(0.8, 1.2)
			$cow_moo_1.play()
		1:
			$cow_moo_2.pitch_scale = randf_range(0.8, 1.2)
			$cow_moo_2.play()
		2:
			$cow_moo_3.pitch_scale = randf_range(0.8, 1.2)
			$cow_moo_3.play()
	reset_moo()
