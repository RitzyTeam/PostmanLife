extends Node3D

@export var street_name: String = ''

func _ready():
	$street_name.text = street_name
	$street_name2.text = street_name
