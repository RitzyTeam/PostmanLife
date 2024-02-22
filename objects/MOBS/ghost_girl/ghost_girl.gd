extends CharacterBody3D

@onready var mesh = $mesh



func _on_appearance_trigger_body_entered(body):
	if body is CharacterBody3D and 'inv' in body and body.has_method('handle_movement'):
		# if it is player
		mesh.visible = true


func _on_appearance_trigger_body_exited(body):
	if body is CharacterBody3D and 'inv' in body and body.has_method('handle_movement'):
		# if it is player
		mesh.visible = false
