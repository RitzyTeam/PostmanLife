extends Node3D

@onready var anim_thunderbolt = $thunderbolt/anim_thunderbolt

func _ready():
	$thunderbolt.global_rotation.y = deg_to_rad(randi_range(0,360))
	anim_thunderbolt.speed_scale = randf_range(0.3, 2.5)
	anim_thunderbolt.play("play")

func _on_thunder_sound_1_finished():
	queue_free()
