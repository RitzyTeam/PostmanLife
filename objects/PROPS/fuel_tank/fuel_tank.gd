extends RigidBody3D

@export var fuel_inside: float = 0

var item: Dictionary = {
	'id': 'fuel_tank',
	'name': 'Канистра бензина',
	'litres': fuel_inside,
	'weight': 0
}

func grab():
	return item

func hurt():
	var blow_obj = load('res://objects/EFFECTS/blow/blow.tscn').instantiate()
	get_tree().get_root().add_child(blow_obj)
	blow_obj.global_position = global_position
	queue_free()
