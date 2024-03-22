extends Marker3D

@export var bird_flying: PackedScene
@onready var spawn_interval = $spawn_interval


func _ready():
	launch_timer()

func launch_timer():
	spawn_interval.wait_time = randi_range(20,120)
	spawn_interval.start()


func _on_spawn_interval_timeout():
	var bird_obj = bird_flying.instantiate()
	add_child(bird_obj)
	await bird_obj.activate()
	bird_obj.queue_free()
	launch_timer()
