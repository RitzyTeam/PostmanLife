extends StaticBody3D

@export var street_name: String = ''

func _ready():
	$street_name_label.text = street_name
