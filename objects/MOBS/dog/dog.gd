extends StaticBody3D

@onready var bark_interval = $bark_interval


func _ready():
	reset_bark()

func reset_bark():
	bark_interval.wait_time = randi_range(20, 50)
	bark_interval.start()

func _on_bark_interval_timeout():
	var bark_id: int = randi_range(1, 5)
	get_node("bark_" + str(bark_id)).pitch_scale = randf_range(0.8, 1.2)
	get_node("bark_" + str(bark_id)).play()
	reset_bark()
