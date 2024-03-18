extends RigidBody3D

var item: Dictionary = {
	'id': 'shotgun',
	'name': 'Дробовик',
	'weight': 4,
	'ammo_inside': 0,
}

func grab():
	return item
