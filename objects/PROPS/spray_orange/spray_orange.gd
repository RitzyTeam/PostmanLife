extends RigidBody3D

var item: Dictionary = {
	'id': 'spray_orange',
	'name': 'Баллончик с краской',
	'weight': 1,
	'paint_amount': 10.0
}

func grab():
	return item
