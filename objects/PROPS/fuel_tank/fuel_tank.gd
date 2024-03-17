extends RigidBody3D

var item: Dictionary = {
	'id': 'fuel_tank',
	'name': 'Канистра бензина',
	'litres': 0,
	'weight': 0
}

func grab():
	return item
