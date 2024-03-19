extends RigidBody3D

var item: Dictionary = {
	'id': 'fuel_tank',
	'name': 'Канистра бензина',
	'litres': 0,
	'weight': 0
}

func grab():
	return item

func hurt():
	var blow_obj = load('res://objects/EFFECTS/blow/blow.tscn').instantiate()
	get_tree().get_root().add_child(blow_obj)
	blow_obj.global_position = global_position
	queue_free()
