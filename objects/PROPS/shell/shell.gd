extends RigidBody3D

var item: Dictionary = {
	'id': 'shell',
	'name': 'Шумовой патрон',
	'weight': 0
}

func grab():
	return item
