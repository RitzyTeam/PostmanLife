extends StaticBody3D


func _on_area_3d_body_entered(body):
	if body.is_in_group('player'):
		body.isOnLadder = true
		body.in_air_momentum = false


func _on_area_3d_body_exited(body):
	if body.is_in_group('player'):
		body.isOnLadder = false
		body.in_air_momentum = true
