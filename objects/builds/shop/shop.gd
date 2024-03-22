extends StaticBody3D

@onready var animation_player = $AnimationPlayer

func _on_area_door_detect_body_entered(body):
	if body.is_in_group('player'):
		if not animation_player.is_playing():
			animation_player.play("doors_open")
		else:
			await animation_player.animation_finished
			animation_player.play("doors_open")

func _on_area_door_detect_body_exited(body):
	if body.is_in_group('player'):
		if not animation_player.is_playing():
			animation_player.play("doors_closed")
		else:
			await animation_player.animation_finished
			animation_player.play("doors_closed")
