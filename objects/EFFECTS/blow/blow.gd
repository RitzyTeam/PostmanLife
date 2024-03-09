extends Node3D

@onready var blow = $blow


func _ready():
	blow.play("blow")

func _on_blow_animation_finished(anim_name):
	queue_free()
