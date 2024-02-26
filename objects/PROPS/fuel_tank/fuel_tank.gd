extends RigidBody3D

var item: Dictionary = {
	'id': 'fuel_tank',
	'name': 'Канистра бензина',
	'litres': 100,
}

func grab():
	return item
