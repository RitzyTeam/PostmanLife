extends RigidBody3D

var item: Dictionary = {
	'id': 'coffee_can',
	'name': 'Баночка кофе',
	'weight': 1,
}

func grab():
	return item
