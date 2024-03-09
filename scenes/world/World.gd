extends Node

@onready var world = $"."

func _ready():
	pass


func _on_world_limiter_body_exited(body):
	print('Penis')
	
	body.queue_free()
