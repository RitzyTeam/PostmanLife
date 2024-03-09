extends Node3D


func blow():
	var blow_effect = load('res://objects/EFFECTS/blow/blow.tscn').instantiate()
	get_tree().get_root().add_child(blow_effect)
	blow_effect.global_position = global_position
	queue_free()


func _on_trigger_body_exited(body):
	if body is CharacterBody3D:
		blow()


func _on_trigger_body_entered(body):
	$mine_stand.play()
